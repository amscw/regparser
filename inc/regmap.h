#ifndef REGMAP_H
#define REGMAP_H

#include <fstream>
#include <vector>
#include <regex>
#include "tracers.h"
#include "exc.h"

struct regmapExc_c : public exc_c
{
	enum class errCode_t : std::uint32_t {
		ERROR_OPENFILE,
		ERROR_PARSE,
		ERROR_EMPTY_REGMAP
	} m_errCode;

	regmapExc_c(enum errCode_t code, const std::string &strFile, const std::string &strFunction, const std::string &strErrorDescription = "") noexcept :
			exc_c(strFile, strFunction, strErrorDescription), m_errCode(code)
	{}

	const std::string &Msg() const noexcept override { return strErrorMessages[(int)m_errCode]; }
	void ToStderr() const noexcept override
	{
		std::cerr << "WTF:" << m_strFile << "(" << m_strFunction << "):" << strErrorMessages[(int)m_errCode] << "-" << m_strErrorDescription << std::endl;
	}

private:
	static std::string strErrorMessages[];
};

/**
 * Варианты хранения регистровой карты
 * 1 последовательный контейнер - вектор пар строка-адрес
 * 2 ассоциативный контейнер - словарь, индексируемый именем регистра
 */
class regmap_c
{
	using regentry_t = std::pair<std::string, std::uint32_t>;
	using regmap_t = std::vector<regentry_t>;
	using regit_t = regmap_t::iterator;

	const char DELIMETER_TOKEN = ';';

	regmap_t regmap;
	std::ifstream m_in;

	std::regex m_rxComment, m_rxValidator, m_rxRegName, m_rxRegNamePrefix, m_rxRegAddr;

public:
	regmap_c (const std::string &filename) throw (regmapExc_c);
	~regmap_c() noexcept;

	size_t Parse() throw (regmapExc_c);
	void ToStdout() throw (regmapExc_c);

private:

};

#endif // REGMAP_H
