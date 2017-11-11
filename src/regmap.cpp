#include "regmap.h"

std::string regmapExc_c::strErrorMessages[] = {
		"can't open file",
		"parse error",
		"regmap is empty"
};

/**
 * экранирование выполнять двойным слешем "\\"
 */
regmap_c::regmap_c(const std::string &filename) throw (regmapExc_c) : m_in(filename, std::ifstream::binary),
	m_rxComment("[ \t]*--[^\n]*(\n|$)"),
	m_rxValidator("^[ \t]*constant[ \t]+ADDR_REG_[A-Z0-9_]+[ \t]*:[ \t]*std_logic_vector[ \t]"
			"*\\([ \t]*OPT_MEM_ADDR_BITS[ \t]+downto[ \t]+0[ \t]*\\)[ \t]*:=[ \t]*x\"[0-9a-fA-F]+\"[\r\n\t\v]*$"),
	m_rxRegName("ADDR_REG_[A-Z0-9_]+"),
	m_rxRegNamePrefix("ADDR_REG_"),
	m_rxRegAddr("x\"[0-9a-fA-F]+\"")
{
	if (!m_in.good())
		throw regmapExc_c(regmapExc_c::errCode_t::ERROR_OPENFILE, __FILE__, __FUNCTION__, filename);
}

regmap_c::~regmap_c() noexcept
{
	m_in.close();
}

size_t regmap_c::Parse() throw (regmapExc_c)
{
	std::ostringstream ossBlock, oss;
	std::string strBlock, str, strRegName, strRegAddr;
	std::smatch match;
	std::uint32_t nRegAddr;

	m_in.seekg(0);
	while (m_in.good())
	{
		// считываем очередной VHDL-оператор
		m_in.get(*ossBlock.rdbuf(), DELIMETER_TOKEN);
		strBlock = std::move(ossBlock.str());

		// удалить комментарии, если имеются
		str.clear();
		std::regex_replace(std::back_inserter(str), strBlock.begin(), strBlock.end(), m_rxComment, "");

		// удалить символы возврата каретки и переноса строки
		strBlock.clear();
		std::regex_replace(std::back_inserter(strBlock), str.begin(), str.end(), std::regex("(\r|\n)"), "");

		if (strBlock.length() > 0)
		{
			std::cout << strBlock << std::endl;

			// валидация строки описания регистра
			if (std::regex_match(strBlock.begin(), strBlock.end(), m_rxValidator))
			{
				// ищем имя регистра
				if (std::regex_search(strBlock, match, m_rxRegName))
				{
					// удалить префикс "ADDR_REG_" и перевести в нижний регистр
					str = match.str();
					strRegName.clear();
					std::regex_replace(std::back_inserter(strRegName), str.begin(), str.end(), m_rxRegNamePrefix, "");
					std::transform(strRegName.begin(), strRegName.end(), strRegName.begin(), ::tolower);
				} else {
					throw (regmapExc_c(regmapExc_c::errCode_t::ERROR_PARSE, __FILE__, __FUNCTION__, strBlock));
				}

				// ищем адрес регистра
				if (std::regex_search(strBlock, match, m_rxRegAddr))
				{
					// удалить кавычки и добавить '0'
					str = match.str();
					strRegAddr = "0";
					std::regex_replace(std::back_inserter(strRegAddr), str.begin(), str.end(), std::regex("\""), "");
					nRegAddr = std::stoul(strRegAddr, nullptr, 16);
				} else {
					throw (regmapExc_c(regmapExc_c::errCode_t::ERROR_PARSE, __FILE__, __FUNCTION__, strBlock));
				}

				// записываем в контейнер
				regmap.emplace_back(regentry_t(strRegName, nRegAddr));

				// oss << "register: \"" << strRegName << "@0x" << std::hex << nRegAddr;
				// TRACE(oss);
			} else {
				oss << "register not valid:(\"" <<  strBlock << "\")";
				TRACE(oss);
			}
		} // if (str.length() > 0)
		// очистить буфер
		ossBlock.str("");
		ossBlock.clear();

		// сдвиг позицици на +1
		m_in.seekg(1, std::ios_base::cur);
	}
	return regmap.size();
}

void regmap_c::ToStdout() throw (regmapExc_c)
{
	if (regmap.size() > 0)
	{
		std::cout << std::hex;
		for (regentry_t reg : regmap)
			std::cout << reg.first << " @0x" << reg.second << ";";
		std::cout << std::endl;
	} else {
		throw regmapExc_c(regmapExc_c::errCode_t::ERROR_EMPTY_REGMAP, __FILE__, __FUNCTION__);
	}
}



