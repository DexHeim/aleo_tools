#!/bin/bash
# Default variables
function="leaderboard"
source="false"

# Options
. <(wget -qO- https://raw.githubusercontent.com/DexHeim/tools/main/colors.sh) --
option_value(){ echo "$1" | sed -e 's%^--[^=]*=%%g; s%^-[^=]*=%%g'; }
while test $# -gt 0; do
	case "$1" in
	-h|--help)
		. <(wget -qO- https://raw.githubusercontent.com/DexHeim/tools/main/logo.sh)
		echo
		echo -e "${C_LGn}Functionality${RES}: the script show Aleo leaderboard info"
		echo
		echo -e "${C_LGn}Usage${RES}: script ${C_LGn}[OPTIONS]${RES}"
		echo
		echo -e "${C_LGn}Options${RES}:"
		echo -e "  -h, --help         show the help page"
		echo
		echo -e "You can use either \"=\" or \" \" as an option and value ${C_LGn}delimiter${RES}"
		echo
		echo -e "https://t.me/DexHeim"
		echo
		return 0
		;;
	*|--)
		break
		;;
	esac
done

leaderboard() {
  local leaderboard_web=$(curl -s  curl https://www.aleo.network/api/leaderboard?search=$(grep "\-\-miner aleo" /etc/systemd/system/aleod-miner.service | grep -Eo "aleo.+"))
  local position=$(echo $leaderboard_web | jq ".leaderboard[0].position")
  local cnt_users=$(echo $leaderboard_web | jq ".count")
  local cnt_blocks_mined=$(echo $leaderboard_web | jq ".leaderboard[0].blocksMined | length")
  local last_block_mined=$(echo $leaderboard_web | jq ".leaderboard[0].lastBlockMined")
  local score=$(echo $leaderboard_web | jq ".leaderboard[0].score")
  local calibration_score=$(echo $leaderboard_web | jq ".leaderboard[0].calibrationScore")
  local block_heigh=$(echo $leaderboard_web | jq ".blockHeight")
  
  printf "
Позиция в рейтинге: ${C_LGn}${position}${RES} из ${C_LGn}${cnt_users}${RES}
Блоков добыто: ${C_LGn}${cnt_blocks_mined}${RES}
Последний добытый блок: ${C_LGn}${last_block_mined}${RES}
Счет / Калибрационный счет: ${C_LGn}${score}${RES} / ${C_LGn}${calibration_score}${RES}
Высота сети: ${C_LGn}${block_heigh}${RES}
"
}

# Install packages
I=`dpkg -s "jq" | grep "Status" `
if [ -z "$I" ]
then
  sudo apt install jq -y &>/dev/null
fi
I=`dpkg -s "curl" | grep "Status"`
if [ -z "$I" ]
then
  sudo apt install curl -y &>/dev/null
fi

#sudo apt install wget, jq, curl -y &>/dev/null
# Actions
. <(wget -qO- https://raw.githubusercontent.com/DexHeim/tools/main/logo.sh)
cd
$function
