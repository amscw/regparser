-----------------------------------------------------------------------------------------
-- Project : FHSS-modem
-- Company: АО "НТЦ Элинс"
-- Author :Мельников Александр Юрьевич
-- Date : 2017-11-30
-- File : axi_pkg.vhd
-- Design: FHSS-modem
-----------------------------------------------------------------------------------------
-- Description : package с регистрами axi
-----------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use ieee.math_real.all;

package Axi_pkg is
	-- Количество регистров AXI
	constant REG_CNT           : integer := 256;
	constant OPT_MEM_ADDR_BITS : integer := integer(ceil(log2(real(REG_CNT*4))));

	-- регистр включения/выключения заворотки MLIP
	constant ADDR_REG_MLIP_LOOP                  : integer := 0;
	-- регистр управления DMA (0 бит - запуск DMA MM2P)
	constant ADDR_REG_DMA_CR                     : integer := 1;
	-- регистр статуса DMA (1 бит - прерывание intr_rx)
	constant ADDR_REG_DMA_SR                     : integer := 2;
	-- регистр включения прерываний DMA (1 бит - прерывание intr_rx)
	constant ADDR_REG_DMA_IR                     : integer := 3;
	-- адрес источника
	constant ADDR_REG_DMA_SA                     : integer := 4;
	-- адрес назначения
	constant ADDR_REG_DMA_DA                     : integer := 5;
	-- длина массива данных DMA для источника 
	constant ADDR_REG_DMA_SL                     : integer := 6;
	-- длина массива данных DMA для получателя (read only) 
	constant ADDR_REG_DMA_DL                     : integer := 7;
	-- регистр статуса MLIP (0-ой бит - intr_tx)
	constant ADDR_REG_MLIP_SR                    : integer := 8;
	-- регистр включения прерываний MLIP (0-ой бит - intr_tx)
	constant ADDR_REG_MLIP_IR                    : integer := 9;
	-- регистр rst MLIP (0-ой бит - Mlip_rst_o)
	constant ADDR_REG_MLIP_RST                   : integer := 10;
	-- регистр ce MLIP (0-ой бит - Mlip_ce_o)
	constant ADDR_REG_MLIP_CE                    : integer := 11;
	-- Включить подсчет битых пакетов (0-ой бит - Mlip_cntcrc_on)
	constant ADDR_REG_MLIP_CNTCRC_ON             : integer := 12;
	-- Включить поле размер пакета в пакете MLIP
	constant ADDR_REG_MLIP_EN_SIZE               : integer := 13;
	-- Включить поле CRC пакета в пакете MLIP
	constant ADDR_REG_MLIP_EN_CRC                : integer := 14;
	-- Порог совпадения преамбулы MLIP
	constant ADDR_REG_MLIP_MATCH_CNT             : integer := 15;
	-- Количество неверных CRC в принятых пакетах
	constant ADDR_REG_MLIP_CNTCRC                : integer := 16;
	-- Размер пакетов MLIP при выключенном поле размера пакета
	constant ADDR_REG_MLIP_SIZE_PACK             : integer := 17;
	-- Сброс Канального и Физического уровня
	constant ADDR_REG_M_RST                      : integer := 18;
	-- Конфигурация Master/Slave (1 - Master, 0 - Slave)
	constant ADDR_REG_M_MASTER                   : integer := 19;
	-- Режим работы (0 - Односторонний, 1 - Симплексный)
	constant ADDR_REG_M_MODE                     : integer := 20;
	-- Регистры DLink Level
	-- Размер пакета синхронизации
	constant ADDR_REG_DLINK_SYNCH_FRAME_SIZE     : integer := 21;
	-- Размер пакета Подтверждения
	constant ADDR_REG_DLINK_ACK_FRAME_SIZE       : integer := 22;
	-- Размер пакета Данных
	constant ADDR_REG_DLINK_DATA_FRAME_SIZE      : integer := 23;
	-- Регистры PHY Level
	-- DBG --
	-- Запись 1 - меняет частоту при выключенном hopper 
	constant ADDR_REG_PHY_DBG_SEL_FREQ           : integer := 24;
	-- Проскальзывание Гарднера Вперед в сэмплах
	constant ADDR_REG_PHY_DBG_GARD_SLIP_FW       : integer := 25;
	-- Проскальзывание гарднера назад в сэмплах
	constant ADDR_REG_PHY_DBG_GARD_SLIP_BW       : integer := 26;
	-- подключение для тестирования valid и sync от мастера к слэйву и обратно
	constant ADDR_REG_PHY_DBG_HALFDUPLEX         : integer := 27;
	-- Включение хоппера
	constant ADDR_REG_PHY_M_EN_HOPPER            : integer := 28;
	-- Степень скользящего среднего в блоке PowerMeter
	constant ADDR_REG_PHY_M_PWRMET_AV_SIZE       : integer := 29;
	-- Включение цифровой заворотки модема
	constant ADDR_REG_PHY_M_LOOP                 : integer := 30;
	-- Включение блока AFC
	constant ADDR_REG_PHY_M_EN_AFC               : integer := 31;
	-- Mu_p для Гарднера
	constant ADDR_REG_PHY_M_GARD_MU_P            : integer := 32;
	-- Заморозка Гарднера
	constant ADDR_REG_PHY_M_GARD_FRZ             : integer := 33;
	-- Порог для эквалайзера
	constant ADDR_REG_PHY_M_TEQ_TH               : integer := 34;
	-- Коэффициент для петлевого фильтра AFC
	constant ADDR_REG_PHY_M_AFC_SCALE            : integer := 35;
	-- Коэффициент расширения полосы ППРЧ
	constant ADDR_REG_PHY_M_BW_FACTOR            : integer := 36;
	-- Смещение Полосы ППРЧ относительно несущей частоты
	constant ADDR_REG_PHY_M_DC_OFFSET            : integer := 37;
	-- Включение проскальзывания в hopper
	constant ADDR_REG_PHY_M_HOP_EN_SLIP          : integer := 38;
	-- Параметр инициализации вихря Мерсена
	constant ADDR_REG_PHY_M_HOP_SEED             : integer := 39;
	-- Период ожидания после проскальзывания
	constant ADDR_REG_PHY_M_HOP_TIMEOUT_AFT_SLIP : integer := 40;
	-- Период проверки ошибки частотной синхронизации с блока PowerMeter
	constant ADDR_REG_PHY_M_HOP_EST_PRD          : integer := 41;
	-- Начальная оценка синхронизации после проскальзывания
	constant ADDR_REG_PHY_M_HOP_EST_START        : integer := 42;
	-- Порог ошибки частной синхронизации
	constant ADDR_REG_PHY_M_HOP_ERR_TH           : integer := 43;
	-- Максимальное значение оценки частотной синхронизации
	constant ADDR_REG_PHY_M_HOP_EST_MAX          : integer := 44;
	-- Размер таблицы частот
	constant ADDR_REG_PHY_M_HOP_LOOKUP_SIZE      : integer := 45;
	-- Включить сброс синхронизации от DlinkLayer
	constant ADDR_REG_PHY_M_HOP_EN_LINK          : integer := 46;
	-- Включение управления аналоговым усилителем передатчика
	constant ADDR_REG_PHY_IC_EN_AMP              : integer := 47;
	-- Включение управления аналоговым усилителем приемника
	constant ADDR_REG_PHY_IC_EN_LNA              : integer := 48;
	-- Включение ручного режима управления аттенюатором 
	constant ADDR_REG_PHY_IC_ATT_MODE            : integer := 49;
	-- Занчение аттенюации при ручном управлении
	constant ADDR_REG_PHY_IC_ATT_VALUE           : integer := 50;
	-- Состояние частотной синхронизации
	constant ADDR_REG_PHY_LOCK_DET               : integer := 51;
	-- Нижний порог петли гистерезиса для AttCtrl
	constant ADDR_REG_PHY_IC_ATT_THLOW           : integer := 52;
	-- Верхний порог петли гистерезиса для AttCtrl
	constant ADDR_REG_PHY_IC_ATT_THHIGH          : integer := 53;
	-- Период обновления значения усиления в AD9361
	constant ADDR_REG_PHY_IC_ATT_UPD_CNT         : integer := 54;

end package Axi_pkg;
