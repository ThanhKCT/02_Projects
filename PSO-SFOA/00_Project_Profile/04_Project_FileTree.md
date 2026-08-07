# 04_Project_FileTree.md

# PROJECT FILE TREE v1.0

    SteelFrameOptimization/
    │
    ├── README.md
    ├── requirements.txt
    ├── .gitignore
    │
    ├── docs/
    │   ├── 01_Framework_Dashboard.md
    │   ├── 02_System_Architecture.md
    │   ├── 03_Implementation_Plan.md
    │   └── 04_Project_FileTree.md
    │
    ├── sap/
    │   ├── MasterModel.sdb
    │   ├── templates/
    │   └── backup/
    │
    ├── python/
    │   ├── main.py
    │   ├── config.py
    │   ├── connector/
    │   │   ├── sap_session.py
    │   │   ├── section_manager.py
    │   │   ├── analysis_runner.py
    │   │   └── result_reader.py
    │   ├── evaluation/
    │   │   ├── evaluation_builder.py
    │   │   ├── force_parser.py
    │   │   ├── displacement_parser.py
    │   │   └── evaluation_data.py
    │   └── tests/
    │       ├── test_connector.py
    │       └── test_evaluation.py
    │
    ├── matlab/
    │   ├── main.m
    │   ├── evaluate.m
    │   ├── objective/
    │   │   └── weight_engine.m
    │   ├── constraint/
    │   │   ├── constraint_engine.m
    │   │   ├── check_geometry.m
    │   │   ├── check_beam.m
    │   │   ├── check_column.m
    │   │   └── check_serviceability.m
    │   ├── penalty/
    │   │   └── penalty_engine.m
    │   ├── fitness/
    │   │   └── fitness_engine.m
    │   ├── pso/
    │   │   ├── pso_main.m
    │   │   ├── initialize_swarm.m
    │   │   ├── update_velocity.m
    │   │   ├── update_position.m
    │   │   ├── update_pbest.m
    │   │   └── update_gbest.m
    │   ├── sfoa/
    │   │   ├── sfoa_main.m
    │   │   ├── initialize_population.m
    │   │   ├── update_position_sfoa.m
    │   │   └── update_best.m
    │   ├── common/
    │   │   ├── config.m
    │   │   ├── logger.m
    │   │   └── utilities.m
    │   └── tests/
    │
    ├── experiment/
    │   ├── experiment_config.m
    │   ├── batch_runner.m
    │   ├── result_collector.m
    │   ├── statistics.m
    │   ├── visualization.m
    │   └── export_results.m
    │
    ├── results/
    │   ├── PSO/
    │   │   ├── run01.mat
    │   │   ├── summary.csv
    │   │   └── figures/
    │   ├── SFOA/
    │   │   ├── run01.mat
    │   │   ├── summary.csv
    │   │   └── figures/
    │   └── comparison/
    │       ├── statistics.xlsx
    │       ├── convergence.png
    │       ├── boxplot.png
    │       └── cpu.png
    │
    ├── paper/
    │   ├── thesis/
    │   ├── journal/
    │   ├── figures/
    │   └── tables/
    │
    └── archive/
        ├── logs/
        ├── backup/
        └── old_versions/

------------------------------------------------------------------------

# Mapping Module → Folder

  Module   Thư mục
  -------- ----------------------------------------------------
  M1       sap/
  M2       python/connector/
  M3       python/evaluation/
  M4       matlab/objective + constraint + penalty + fitness/
  M5       matlab/pso/
  M6       matlab/sfoa/
  M7       experiment/ + results/
  M8       paper/

------------------------------------------------------------------------

# Quy tắc quản lý

-   Mỗi file chỉ có một nhiệm vụ.
-   Mỗi thư mục tương ứng với một nhóm chức năng.
-   Không trộn Python và MATLAB.
-   Không ghi kết quả thực nghiệm vào thư mục source.
-   Mọi kết quả chạy lưu trong `results/`.
-   Tài liệu luôn lưu trong `docs/`.

------------------------------------------------------------------------

# Thứ tự triển khai

1.  sap/
2.  python/
3.  matlab/
4.  experiment/
5.  results/
6.  paper/

Đây là cấu trúc thư mục chuẩn cho toàn bộ dự án và sẽ không thay đổi
trong giai đoạn Implementation (Design Freeze v1.0).
