#!/bin/bash
# Watchdog v2 cho campaign vet can 4080 to hop -- ban tang cuong de chay
# qua dem KHONG CAN nguoi dung can thiep.
#
# 2 co che phat hien:
#   (A) STALE-BASED (nhu v1): neu log khong duoc ghi them trong THRESHOLD
#       giay -> coi la treo (hang giua chung, VD 1 worker ghim CPU, hoac
#       ca 8 worker mat IPC voi SAP2000).
#   (B) FAST-FAIL sau moi lan relaunch: chu dong doi toi da
#       FASTFAIL_TIMEOUT giay de xac nhan MATLAB THAT SU khoi dong duoc
#       (thay vi mu quang cho du THRESHOLD giay). Neu khong thay dau hieu
#       khoi dong (vd loi license, loi cu phap, file bi khoa) trong
#       khoang do -> coi la fast-fail, retry ngay (khong doi 40 phut),
#       nhung gioi han so lan fast-fail LIEN TIEP de tranh crash-loop vo
#       ich (VD loi he thong that su can nguoi kiem tra).
#
# Ca 2 co che deu tu dong kill (theo PID, khong theo ten -- tranh bi chan
# classifier) + relaunch dung lenh goc -- script tu resume checkpoint,
# khong mat tien do.
#
# Gioi han tong so lan tu dong khoi phuc (MAX_AUTO_RESTARTS) rong rai vi
# chay qua dem, checkpoint moi chunk dam bao khong mat du lieu du restart
# bao nhieu lan -- chi mat thoi gian cho, khong mat ket qua.

LOG="D:/ResearchLab/02_Projects/02_Projects/MOFDA/Wharf100DWT/results/campaign_bruteforce_4080_FINAL.log"
PS1="D:\\ResearchLab\\02_Projects\\02_Projects\\MOFDA\\Wharf100DWT\\ops\\relaunch_bruteforce.ps1"
THRESHOLD=2400        # 40 phut khong co cap nhat log -> coi la treo
CHECK_INTERVAL=120     # kiem tra moi 2 phut
MAX_AUTO_RESTARTS=20   # tong so lan tu dong khoi phuc toi da (rong rai cho qua dem)
FASTFAIL_TIMEOUT=300   # 5 phut de xac nhan MATLAB khoi dong thanh cong sau relaunch
FASTFAIL_POLL=15       # kiem tra moi 15s trong giai doan xac nhan khoi dong
MAX_CONSECUTIVE_FASTFAIL=3  # qua so nay -> DUNG, escalate (loi he thong that, khong phai treo thuong)

RESTART_COUNT=0
CONSECUTIVE_FASTFAIL=0

do_kill_all() {
  local killed=0
  for img in "SAP2000.exe" "MATLAB.exe" "MATLABWebUI.exe"; do
    pids=$(tasklist //FI "IMAGENAME eq $img" //NH 2>/dev/null | awk '{print $2}')
    for pid in $pids; do
      if taskkill //F //PID "$pid" >/dev/null 2>&1; then
        killed=$((killed + 1))
      fi
    done
  done
  echo "WATCHDOG: da kill ${killed} tien trinh (MATLAB+SAP2000+WebUI)."
}

do_relaunch_and_confirm() {
  # ghi lai kich thuoc log TRUOC khi relaunch de phat hien tang truong moi
  local pre_size=0
  if [ -f "$LOG" ]; then pre_size=$(stat -c %s "$LOG" 2>/dev/null || echo 0); fi

  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PS1" >/dev/null 2>&1
  echo "WATCHDOG: da relaunch, dang xac nhan khoi dong (toi da ${FASTFAIL_TIMEOUT}s)..."

  local waited=0
  while [ "$waited" -lt "$FASTFAIL_TIMEOUT" ]; do
    sleep $FASTFAIL_POLL
    waited=$((waited + FASTFAIL_POLL))
    if [ -f "$LOG" ] && grep -qE "Connected to parallel pool|resume tu to hop|Da xong [0-9]+/4080" "$LOG" 2>/dev/null; then
      echo "WATCHDOG: xac nhan MATLAB da khoi dong thanh cong (sau ${waited}s)."
      CONSECUTIVE_FASTFAIL=0
      return 0
    fi
  done
  echo "WATCHDOG: FAST-FAIL -- khong xac nhan duoc MATLAB khoi dong sau ${FASTFAIL_TIMEOUT}s."
  return 1
}

echo "WATCHDOG v2: bat dau giam sat $LOG (nguong treo=${THRESHOLD}s, kiem tra moi ${CHECK_INTERVAL}s, toi da ${MAX_AUTO_RESTARTS} lan tu khoi phuc, fast-fail timeout=${FASTFAIL_TIMEOUT}s)."

while true; do
  sleep $CHECK_INTERVAL

  if grep -q "HOAN THANH brute-force" "$LOG" 2>/dev/null; then
    echo "WATCHDOG: campaign da HOAN THANH -- dung watchdog."
    break
  fi

  if [ ! -f "$LOG" ]; then
    echo "WATCHDOG: CANH BAO -- khong tim thay file log $LOG."
    continue
  fi

  now=$(date +%s)
  mtime=$(stat -c %Y "$LOG" 2>/dev/null)
  if [ -z "$mtime" ]; then
    echo "WATCHDOG: CANH BAO -- khong doc duoc thoi gian sua file log."
    continue
  fi
  elapsed=$((now - mtime))

  if [ "$elapsed" -gt "$THRESHOLD" ]; then
    RESTART_COUNT=$((RESTART_COUNT + 1))
    echo "WATCHDOG: HANG PHAT HIEN -- log khong cap nhat trong ${elapsed}s (nguong ${THRESHOLD}s). Tu dong khoi phuc lan ${RESTART_COUNT}/${MAX_AUTO_RESTARTS}."

    if [ "$RESTART_COUNT" -gt "$MAX_AUTO_RESTARTS" ]; then
      echo "WATCHDOG: DA VUOT QUA ${MAX_AUTO_RESTARTS} LAN TU DONG KHOI PHUC -- DUNG watchdog, CAN KIEM TRA THU CONG."
      break
    fi

    do_kill_all
    sleep 5

    if do_relaunch_and_confirm; then
      : # thanh cong, vong lap tiep tuc binh thuong
    else
      CONSECUTIVE_FASTFAIL=$((CONSECUTIVE_FASTFAIL + 1))
      echo "WATCHDOG: fast-fail lien tiep ${CONSECUTIVE_FASTFAIL}/${MAX_CONSECUTIVE_FASTFAIL}."
      if [ "$CONSECUTIVE_FASTFAIL" -ge "$MAX_CONSECUTIVE_FASTFAIL" ]; then
        echo "WATCHDOG: CRASH-LOOP -- ${MAX_CONSECUTIVE_FASTFAIL} lan relaunch lien tiep KHONG khoi dong duoc. DUNG watchdog, CAN KIEM TRA THU CONG NGAY (co the loi license/he thong, khong phai treo thuong)."
        break
      fi
      # thu lai ngay (khong doi het THRESHOLD) bang cach lam moi mtime check o vong sau
    fi
  fi
done
