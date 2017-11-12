LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

package axi_pkg is
	constant OPT_MEM_ADDR_BITS : integer := 15;

	-- Регистры MLIP и DMA --
	-- регистр включения/выключения заворотки MLIP
	constant ADDR_REG_MLIP_LOOP      : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0000";
	-- регистр управления DMA (0 бит - запуск DMA MM2P)
	constant ADDR_REG_DMA_CR         : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0004";
	-- регистр статуса DMA (1 бит - прерывание intr_rx)
	constant ADDR_REG_DMA_SR         : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0008";
	-- регистр включения прерываний DMA (1 бит - прерывание intr_rx)
	constant ADDR_REG_DMA_IR         : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"000C";
	-- адрес источника
	constant ADDR_REG_DMA_SA         : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0010";
	-- адрес назначения
	constant ADDR_REG_DMA_DA         : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0014";
	-- длина массива данных DMA для источника 
	constant ADDR_REG_DMA_SL         : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0018";
	-- длина массива данных DMA для получателя (read only) 
	constant ADDR_REG_DMA_DL         : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"001C";
	-- регистр статуса MLIP (0-ой бит - intr_tx)
	constant ADDR_REG_MLIP_SR        : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0020";
	-- регистр включения прерываний MLIP (0-ой бит - intr_tx)
	constant ADDR_REG_MLIP_IR        : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0024";
	-- регистр rst MLIP (0-ой бит - Mlip_rst_o)
	constant ADDR_REG_MLIP_RST       : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0028";
	-- регистр ce MLIP (0-ой бит - Mlip_ce_o)
	constant ADDR_REG_MLIP_CE        : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"002C";
	-- Включить подсчет битых пакетов (0-ой бит - Mlip_cntcrc_on)
	constant ADDR_REG_MLIP_CNTCRC_ON : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0030";
	-- Счетчик битых пакетов MLIP (16 младших бит) (read only)
	constant ADDR_REG_MLIP_CNTCRC    : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0034";

	-- Регистры модема --
	-- rst MODEM (0-ой бит - m_rst_o)
	constant ADDR_REG_M_RST          : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0038";
	-- цифровая заворотка FPGA loop_back MODEM (0-ой бит - m_loop_back_o)
	constant ADDR_REG_M_LOOP         : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"003C";
	-- look_detect MODEM (0-ой бит - m_look_detect_i) - read only
	constant ADDR_REG_M_LOOK_DET     : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0040";
	-- Включение модулятора m_en_mod_o MODEM (0-ой бит - m_en_mod_o) 
	constant ADDR_REG_M_EN_MOD       : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0044";
	-- Включение модулятора m_en_demod_o MODEM (0-ой бит - m_en_demod_o) 
	constant ADDR_REG_M_EN_DEMOD     : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0048";
	-- Включение hopper m_en_hopper_o MODEM (0-ой бит - m_en_hopper_o) 
	constant ADDR_REG_M_EN_HOPPER    : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"004C";
	-- Ручное переклюдчение частоты m_select_freq_o MODEM (строб по моменту записи в 0-ой бит единицы) 
	constant ADDR_REG_M_SEL_FREQ     : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0050";
	-- Инициализация Вихря Мерсена m_seed (32 бита) 
	constant ADDR_REG_M_SEED         : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0054";
	-- Глубина усреднения ошибки гарднера m_average_size_o (16 младших бит) 
	--constant ADDR_REG_M_SOFT_CNT     : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0058";
	-- Период проскальзывания по частоте RX m_decision_prd_o (16 младших бит) 
	constant ADDR_REG_M_DEC_PRD      : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"005C";
	-- Граничное значение ошибки Гарднера (16 младших бит) 
	--constant ADDR_REG_M_SOFT_RANGE   : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0060";
	-- Граничное значение ошибки Гарднера (16 младших бит) 
	--constant ADDR_REG_M_SOFT_MAX     : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0064";
	-- Граничное значение ошибки Гарднера (16 младших бит) 
	--constant ADDR_REG_M_SOFT_TH      : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0068";
	-- размерность сетки частот m_lookup_size_o (16 младших бит) 
	constant ADDR_REG_M_LOOKUP_SIZE  : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"006C";
	--  (0-ой бит - m_ad_enable_o) 
	constant ADDR_REG_M_AD_EN        : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0070";
	-- (0-ой бит - m_ad_txnrx_o)  
	constant ADDR_REG_M_AD_TXNRX     : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0074";
	-- (0-ой бит - m_ad_inc_o)  
	--constant ADDR_REG_M_AD_INC       : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0078";
	-- (0-ой бит - m_ad_dec_o)  
	--constant ADDR_REG_M_AD_DEC       : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"007C";
	-- (0-ой бит - m_ad_bust_conf_o)  
	--constant ADDR_REG_M_AD_BUST_CONF : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0080";
	-- (7 младших бит - m_ad_light_i) (read only)  
	constant ADDR_REG_M_AD_LIGHT     : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0084";
	-- (0-ой бит - cic_en)  
	--constant ADDR_REG_M_EN_CIC       : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0088";
	-- (0-ой бит - afc_en)  
	--constant ADDR_REG_M_EN_AFC       : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"008C";
	-- (0-ой бит - agc_en)  
	--constant ADDR_REG_M_EN_AGC       : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0090";
	-- (0-ой бит - agc_en)  
	--constant ADDR_REG_M_EN_FARROW    : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0094";
	-- (0-ой бит - agc_en)  
	--constant ADDR_REG_M_EN_TEQ       : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0098";
	-- (0-ой бит - agc_en)  
	--constant ADDR_REG_M_EN_RRC       : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"009C";
	-- (0-ой бит - agc_en)  
	constant ADDR_REG_M_TYPE_SYNC    : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00A0";
	-- (0-ой бит - agc_en)  
	constant ADDR_REG_M_TEQ_TH       : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00A4";
	-- (0-ой бит - agc_en)  
	constant ADDR_REG_M_PWR_AV_SIZE  : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00A8";
	-- (0-ой бит - agc_en)  
	constant ADDR_REG_M_SCALE_RANGE  : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00AC";
	-- (0-ой бит - agc_en)  
	constant ADDR_REG_M_OFFSET       : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00B0";
	-- (16 младших бит - gardner_mu_p) 
	constant ADDR_REG_M_GARD_MU_P    : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00B4";
	-- (16 младших бит - gardner_start) 
	constant ADDR_REG_M_GARD_FRZ     : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00B8";
	-- (0-ой бит - slip_on)  
	constant ADDR_REG_M_HOPPER_SLIP  : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00BC";
	-- (16 младших бит - cnt_sma) 
	constant ADDR_REG_M_CNT_SMA      : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00C0";
	-- (16 младших бит - cnt_sma) 
	constant ADDR_REG_M_AGC_GAIN     : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00C4";
	-- счетчик прерываний TX
	constant ADDR_REG_MLIP_CNT_TX    : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00C8";
	-- Счетчик рперываний RX
	constant ADDR_REG_MLIP_CNT_RX    : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00CC";
	-- Ручное проскальзывание вперед
	constant ADDR_REG_M_GARD_SLIP_FW : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00D0";
	-- Ручное проскальзывание назад
	constant ADDR_REG_M_GARD_SLIP_BW : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00D4";
	--constant ADDR_REG_M_ATT          : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00D8";
	--constant ADDR_REG_M_AFC_SCALE    : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00DC";
	constant ADDR_REG_MLIP_EN_SIZE   : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00E0";
	constant ADDR_REG_MLIP_EN_CRC    : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00E4";
	constant ADDR_REG_MLIP_MATCH_CNT : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00E8";
	constant ADDR_REG_MLIP_SIZE_PACK : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00EC";
	--constant ADDR_REG_M_ATT_MANUAL   : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00F0";
	--constant ADDR_REG_M_ATT_AVSIZE   : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00F4";
	--constant ADDR_REG_M_ATT_THLOW    : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00F8";
	--constant ADDR_REG_M_ATT_THHIGH   : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"00FC";
	--constant ADDR_REG_M_ATT_UPDCNT   : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0100";
	constant ADDR_REG_M_TEQ_PH       : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0104";
	constant ADDR_REG_CFG_MASTER     : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0108";
	constant ADDR_REG_EN_HALFDUPLEX  : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"010C";
	constant ADDR_REG_BIT2TX         : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0110";
	constant ADDR_REG_BIT2RX         : std_logic_vector(OPT_MEM_ADDR_BITS downto 0) := x"0114";

end package axi_pkg;
