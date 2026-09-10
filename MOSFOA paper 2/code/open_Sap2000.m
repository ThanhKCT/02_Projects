function open_Sap2000(h)
% OPEN_SAP2000  Mo SAP2000 an (headless) qua bo cong cu SM.* da kiem chung.
%
% Copy nguyen mau tu "Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md" muc 2 -
% KHONG sua doi cach goi (da kiem chung chay on dinh nhieu gio lien tuc).
%
%   open_Sap2000(1)  -> mo an hoan toan (dung cho batch/song song)
%   open_Sap2000(0)  -> mo hien cua so (dung khi debug/xem truc tiep)
%
% YEU CAU: bo toolkit SM.* phai co san tren MATLAB path (du an cua ban da
% co san theo "Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md"). Neu chua co
% SM.*, xem ban thay the raw-COM o cuoi file (CHUA kiem chung on dinh bang
% SM.*, chi dung khi khong co lua chon khac - xem canh bao trong do).

SM.App('sap'); SM.Ver('24');
ProgramPath = 'C:\Program Files\Computers and Structures\SAP2000 24\SAP2000.exe';
APIDLLPath  = 'C:\Program Files\Computers and Structures\SAP2000 24\SAP2000v1.dll';
[Sobj] = SM.Helper.CreateObject(ProgramPath, APIDLLPath); %#ok<NASGU>
[Smdl] = SM.SapModel(); %#ok<NASGU>
if h==1
    SM.ApplicationStart('Visible', false)  % KHONG hien cua so ngay tu dau
    SM.Hide;
else
    SM.ApplicationStart
end
end

% ---------------------------------------------------------------------
% BAN THAY THE RAW-COM (chi dung neu KHONG co SM.* tren may) — dua tren
% thu nghiem thuc te 09/09/2026 khi viet khung code nay:
%   - ApplicationStart() 0-arg BI LOI qua ca PowerShell lan MATLAB actxserver
%     tren may nay ("Cannot find an overload") — phai goi ro 3 tham so.
%   - PowerShell (non-interactive) bi TREO VINH VIEN o OpenFile — dung
%     KHOP voi canh bao muc 6.6 cua file huong dan (thieu message pump).
%   - MATLAB actxserver qua duoc ApplicationStart nhung OpenFile tra ve
%     loi "The parameter is incorrect" (ret=1) — CHUA xac dinh duoc
%     nguyen nhan chinh xac, co the do cu phap invoke() cho tham so string
%     don gian chua dung chuan actxserver — CAN KIEM CHUNG THEM neu dinh
%     dung nhanh nay thay cho SM.*.
%
% function open_Sap2000_rawcom()
%     helper = actxserver('SAP2000v1.Helper');
%     SapObject = helper.CreateObjectProgID('CSI.SAP2000.API.SapObject');
%     ret = SapObject.invoke('ApplicationStart', 6, false, ''); % 6 = kN_m_C
%     SapModel = SapObject.invoke('SapModel');
% end
% ---------------------------------------------------------------------
