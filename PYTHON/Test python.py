import sys
import comtypes.client

def check_max_workers(max_test=10):
    instances = []
    print("=== ĐANG KIỂM TRA SỐ WORKER TỐI ĐA CHẠY ĐỒNG THỜI ===")
    sys.stdout.flush()
    
    # 1. Khởi tạo Helper
    try:
        helper = comtypes.client.CreateObject('SAP2000v1.Helper')
    except Exception as e:
        print(f"[X] Không thể tạo Helper: {e}")
        return

    # 2. Vòng lặp thử khởi tạo liên tiếp các instance
    for i in range(1, max_test + 1):
        try:
            print(f"\n[+] Đang thử mở Instance #{i}...")
            sys.stdout.flush()
            
            # Tạo instance SAP2000 mới
            sap_obj = helper.CreateObjectProgID("CSI.SAP2000.API.SapObject")
            sap_obj.ApplicationStart()
            
            # Giữ lại instance trong danh sách (chưa đóng)
            instances.append(sap_obj)
            print(f"    -> Mở thành công Instance #{i}!")
            sys.stdout.flush()
            
        except Exception as e:
            print(f"    [!] Dừng lại ở Instance #{i}. Lý do / Lỗi License: {e}")
            break

    # 3. Kết luận
    total_workers = len(instances)
    print("\n" + "="*40)
    print(f"=> KẾT LUẬN: Số worker SAP2000 tối đa chạy đồng thời là: {total_workers}")
    print("="*40)

    # 4. Dọn dẹp: Đóng tất cả các instance đã mở thử nghiệm
    print("\nĐang dọn dẹp và đóng các instance thử nghiệm...")
    for idx, obj in enumerate(instances, 1):
        try:
            obj.ApplicationExit(False)
            print(f" -> Đã đóng Instance #{idx}")
        except:
            pass
    print("Đã hoàn tất dọn dẹp!")

if __name__ == "__main__":
    check_max_workers(max_test=10)