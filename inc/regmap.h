#ifndef REGMAP_H
#define REGMAP_H

#include <fstream>
#include <vector>
#include <regex>
#include <list>
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
 * Дескриптор группы регистров
 * nodeName - имя каталога
 * regs - список файлов каталога
 */
struct regentry_c
{
	using reg_t = std::pair<std::string, std::uint32_t>;

	std::string nodeName;
	std::list<reg_t> regs;
};

/**
 * Функтор для определения факта наличия узла в указанном списке
 */
struct IsExistIn : public std::unary_function
{
	IsExistIn(const std::list<regentry_c> &entries) : m_entries(entries) {};

	inline bool operator ()(const std::string &nodeName)
	{
		for (auto e : m_entries) {
			if (e.nodeName == nodeName)
				return true;
		}
		return false;
	}

private:
	const std::list<regentry_c> &m_entries;
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
