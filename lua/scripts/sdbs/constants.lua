-- constants

--[[CR_ROOT = 4
CR_REFEREE = 3
CR_REGISTERED = 2]]

LOGIN = 1
LOGOUT = 0
LOGOUT_FORCE = -1

ON = 'ON'
OFF = 'OFF'
YES = 'YES'
NO = 'NO'
NEUTRAL = 'NEUTRAL'
NUM = 'NUM'
NONE = 'NONE'
VOTE = 'VOTE'
AUTO = 'AUTO'
MASTER = 'MASTER'
BLACKLIST = 'BLACKLIST'

EOP = 'EOP'
CN = 'CN'
MKICK = 'MKICK'
MBAN = 'MBAN'
TAGT = 'TAGT'
BANREFUSE = 'BANREFUSE'
WRONGPW = 'WRONGPW'
SOPLOGINFAIL = 'SOPLOGINFAIL'
MAXCLIENTS = 'MAXCLIENTS'
MASTERMODE = 'MASTERMODE'
AUTOKICK = 'AUTOKICK'
AUTOBAN = 'AUTOBAN'
DUP = 'DUP'
BADNICK = 'BADNICK'
OVERFLOW = 'OVERFLOW'
ABUSE = 'ABUSE'
AFK = 'AFK'
FFIRE = 'FFIRE'
CHEAT = 'CHEAT'

-- ROLE --

DEFAULT = 'DEFAULT'
ADMIN = 'ADMIN'
REGISTERED = 'REGISTERED'
REFEREE = 'REFEREE'
ROOT = 'ROOT'
AD ='AD'
REF = 'REF'
ROT = 'ROT'
REG = 'REG'
DEF = 'DEF'

-- FLAG --
PICKUP = 'PICKUP'
STEAL = 'STEAL'
DROP = 'DROP'
LOST = 'LOST'
RETURN = 'RETURN'
SCORE = 'SCORE'
RESET = 'RESET'

-- TEAM --

CLA = 'CLA'
RVSF = 'RVSF'
CLA_SPECT = 'CLA_SPECT'
RVSF_SPECT = 'RVSF_SPECT'
SPECT = 'SPECT'
ANYACTIVE = 'ANYACTIVE'

-- MODE --

DEMO = 'DEMO'
TDM = 'TDM'
COOP = 'COOP'
DM = 'DM'
SURV = 'SURV'
TSURV = 'TSURV'
CTF = 'CTF'
PF = 'PF'
LSS = 'LSS'
OSOK = 'OSOK'
TOSOK = 'TOSOK'
HTF = 'HTF'
TKTF = 'TKTF'
KTF = 'KTF'

-- VOTE TYPE --

KICK = 'KICK'
BAN = 'BAN'
REMBANS = 'REMBANS'
AUTOTEAM = 'AUTOTEAM'
FORCETEAM = 'FORCETEAM'
GIVEADMIN = 'GIVEADMIN'
MAP = 'MAP'
RECORDDEMO = 'RECORDDEMO'
STOPDEMO = 'STOPDEMO'
CLEARDEMOS = 'CLEARDEMOS'
SERVERDESC = 'SERVERDESC'
SHUFFLETEAMS = 'SHUFFLETEAMS'

-- GUN --

KNIFE = 'KNIFE'
PISTOL = 'PISTOL'
CARBINE = 'CARBINE'
SHOTGUN = 'SHOTGUN'
SUBGUN = 'SUBGUN'
SNIPER = 'SNIPER'
ASSAULT = 'ASSAULT'
CPISTOL = 'CPISTOL'
GRENADE = 'GRENADE'
AKIMBO = 'AKIMBO'

-- ERROR --
NOT_PLAYER = 'NOT_PLAYER'
NOT_IP = 'NOT_IP'
NOT_GENERATE = 'NOT_GENERATE'
NOT_DATA = 'NOT_DATA'
NOT_EMAIL = 'EMPTY_EMAIL'
NOT_VALID_EMAIL = 'NOT_VALID_EMAIL'


-- TMR

TMR_MYSQL_CONNECTOR = 1
TMR_CHK_AUTOTEAM = 2
TMR_CONNECT_SAY = 100 -- до 149 ~ 50 клиентов
TMR_STOPWATCH = 150 -- диапазон занят от 150 до 199 ~ 50 клиентов
TMR_SERVER_MESSAGES = 200 -- диапазон занят от 200 до 299 100 рекламных текстовых роликов )))

TMR_SERVER_SERVICE = 300 -- диапазон занят от 300 до 399 100 таймеров )))

-- consolelog

LOG_INFO = 2
LOG_WARN = 3
LOG_ERR = 4

-- say messages
-- 0  green, 1 blue, 2 yellow, 3 red, 4 gray, 5 white, 9 orange,
SAY_TEXT = '\f2'
SAY_NORMAL = '\f0'
SAY_INFO = '\f1'
SAY_WARN = '\f9'
SAY_ERR = '\f3'
SAY_SYS = '\f5'
SAY_GRAY = '\f4'
SAY_LIGHTGRAY = '\fY'
SAY_DARKGRAY = '\fZ'
SAY_MAGENTA = '\fX'
SAY_ENABLED_0 = '\f0ENABLED '
SAY_ENABLED_3 = '\f3ENABLED '
SAY_DISABLED_0 = '\f0DISABLED '
SAY_DISABLED_3 = '\f3DISABLED '
SAY_TAB = '    '
SAY_NTAB = '\n'..SAY_TAB


L_SPECL = { '`','~','!','#','$','%','^','&','*','(',')','=','+',"\\",'|','{','}','[',']','/','?','>','<',',',':',';','"',"'" }

L_chk_EMAIL = { '@', '.' }

-- color

C_CN_CODES = { "\f0", "\f1", "\f2", "\f3", "\f5", "\f9", "\fB", "\fJ", "\fP", "\fV", "\fX", "\fY" }

C_CODES = { "\f0", "\f1", "\f2", "\f3", "\f4", "\f5", "\f6", "\f7", "\f8", "\f9", "\fA", "\fB", "\fC", "\fD", "\fE", "\fF", "\fG", "\fH", "\fI", "\fJ", "\fK", "\fL", "\fM", "\fN", "\fO", "\fP", "\fQ", "\fR", "\fS", "\fT", "\fU", "\fV", "\fW", "\fX", "\fY", "\fZ"}
CC_LOOKUP = { "\\f0", "\\f1", "\\f2", "\\f3", "\\f4", "\\f5", "\\f6", "\\f7", "\\f8", "\\f9", "\\fA", "\\fB", "\\fC", "\\fD", "\\fE",
  "\\fF", "\\fG", "\\fH", "\\fI", "\\fJ", "\\fK", "\\fL", "\\fM", "\\fN", "\\fO", "\\fP", "\\fQ", "\\fR", "\\fS", "\\fT",
  "\\fU", "\\fV", "\\fW", "\\fX", "\\fY", "\\fZ"}

if sdbs.flag.C_LOG then  logline(LOG_INFO,'SDBS: Player SYSTEM says: Module constants init OK') end