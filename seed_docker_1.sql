-- ===================================================================
--  TOPIC: Docker (song ngữ VI + EN, ví dụ). File 1: cấu trúc + Core
-- ===================================================================
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_docker','Docker','DevOps & Cloud',
'Đóng gói ứng dụng + phụ thuộc vào container chạy giống nhau mọi nơi:
image vs container, Dockerfile, layer & cache, registry, volume, network,
Docker Compose, multi-stage build và best practices.',
'Package an app + its dependencies into containers that run the same
everywhere: images vs containers, Dockerfile, layers & cache, registries,
volumes, networks, Docker Compose, multi-stage builds, and best practices.',
'[]',0,-600),

('s_dk_core','Docker Core','DevOps & Cloud',
'Khái niệm image vs container, Dockerfile, layer & cache, và registry.',
'Image vs container concepts, the Dockerfile, layers & cache, and registries.',
'[]',-120,-660),
('s_dk_run','Chạy & Kết nối','DevOps & Cloud',
'Volume (lưu dữ liệu), network, cổng & biến môi trường, và Docker Compose.',
'Volumes (data persistence), networks, ports & env vars, and Docker Compose.',
'[]',120,-660),
('s_dk_ops','Tối ưu & Vận hành','DevOps & Cloud',
'Multi-stage build, giảm kích thước image & best practices, healthcheck/log/debug.',
'Multi-stage builds, shrinking images & best practices, healthchecks/logs/debug.',
'[]',0,-720),

-- ------------------------- CORE -----------------------------------
('n_dk_concept','Image vs Container (vs VM)','DevOps & Cloud',
'Docker đóng gói ứng dụng + mọi phụ thuộc vào một CONTAINER chạy giống hệt
ở mọi nơi -> hết cảnh "máy tôi chạy được mà".

IMAGE vs CONTAINER:
  • Image     : bản mẫu ĐÓNG BĂNG (chỉ đọc) gồm OS nền + code + thư viện.
    Giống một "class".
  • Container : một tiến trình ĐANG CHẠY từ image (có thêm lớp ghi tạm).
    Giống một "object" (instance của image).
  Một image -> tạo được NHIỀU container.

KHÁC MÁY ẢO (VM):
  VM        : ảo hóa cả phần cứng + OS đầy đủ -> nặng (GB), khởi động chậm.
  Container : CHIA SẺ kernel của host, chỉ đóng gói tiến trình + deps
              -> nhẹ (MB), khởi động mili-giây.

  [Cont A][Cont B]            [VM A][VM B]
   -- Docker Engine --         -- Guest OS mỗi VM --
   --- Host OS / Kernel ---    ------ Hypervisor ------

LỆNH CƠ BẢN:
  docker run nginx         # tải image + tạo & chạy container
  docker ps                # container đang chạy (ps -a: tất cả)
  docker images            # danh sách image
  docker stop/rm <id>      # dừng/xóa container (rmi: xóa image)
  docker exec -it <id> sh  # vào shell bên trong container

MẸO: image = khuôn (bất biến), container = instance đang chạy. Container
"ephemeral" — dữ liệu mất khi xóa -> cần VOLUME để lưu bền.',
'Docker packages an app + all its dependencies into a CONTAINER that runs
identically everywhere -> no more "but it works on my machine".

IMAGE vs CONTAINER:
  • Image     : a FROZEN read-only template with a base OS + code + libraries.
    Like a "class".
  • Container : a RUNNING process created from an image (plus a temporary
    writable layer). Like an "object" (an instance of the image).
  One image -> creates MANY containers.

VS A VIRTUAL MACHINE (VM):
  VM        : virtualizes hardware + a full OS -> heavy (GB), slow to boot.
  Container : SHARES the host kernel, packaging only the process + deps
              -> light (MB), boots in milliseconds.

  [Cont A][Cont B]            [VM A][VM B]
   -- Docker Engine --         -- Guest OS per VM --
   --- Host OS / Kernel ---    ------ Hypervisor ------

BASIC COMMANDS:
  docker run nginx         # pull image + create & run a container
  docker ps                # running containers (ps -a: all)
  docker images            # list images
  docker stop/rm <id>      # stop/remove a container (rmi: remove an image)
  docker exec -it <id> sh  # open a shell inside a container

TIP: image = the mold (immutable), container = the running instance.
Containers are "ephemeral" - data is lost on removal -> use a VOLUME to
persist it.',
'[]',-200,-700),

('n_dk_dockerfile','Dockerfile','DevOps & Cloud',
'Dockerfile là công thức dạng TEXT để build một image, gồm các chỉ thị
xếp theo tầng.

  FROM node:20-alpine        # image nền (bắt buộc, dòng đầu)
  WORKDIR /app               # thư mục làm việc trong container
  COPY package*.json ./      # copy trước để tận dụng cache
  RUN npm ci                 # chạy lệnh lúc BUILD -> tạo một layer
  COPY . .                   # copy toàn bộ source
  EXPOSE 3000                # (tài liệu) cổng app lắng nghe
  ENV NODE_ENV=production    # biến môi trường
  CMD ["node", "server.js"]  # lệnh chạy khi container KHỞI ĐỘNG

CHỈ THỊ QUAN TRỌNG:
  • FROM      : image gốc.
  • RUN       : chạy lệnh lúc build (cài gói, biên dịch) -> tạo layer.
  • COPY/ADD  : đưa file vào image (COPY ưu tiên; ADD thêm giải nén/URL).
  • CMD vs ENTRYPOINT: CMD = lệnh mặc định (ghi đè được); ENTRYPOINT = lệnh
    cố định, CMD trở thành tham số cho nó.
  • WORKDIR, ENV, EXPOSE, ARG (biến lúc build), USER (chạy non-root).

BUILD & CHẠY:
  docker build -t myapp:1.0 .
  docker run -p 3000:3000 myapp:1.0

MẸO: dùng .dockerignore (bỏ node_modules, .git) để build nhanh + image gọn.
Gộp lệnh RUN bằng && để bớt layer. CMD dạng MẢNG (exec form) tốt hơn dạng
chuỗi (nhận tín hiệu dừng đúng).',
'A Dockerfile is a TEXT recipe to build an image, made of layered instructions.

  FROM node:20-alpine        # base image (required, first line)
  WORKDIR /app               # working directory inside the container
  COPY package*.json ./      # copy first to leverage caching
  RUN npm ci                 # runs at BUILD time -> creates a layer
  COPY . .                   # copy the whole source
  EXPOSE 3000                # (documentation) the port the app listens on
  ENV NODE_ENV=production    # environment variable
  CMD ["node", "server.js"]  # command run when the container STARTS

KEY INSTRUCTIONS:
  • FROM      : the base image.
  • RUN       : run a command at build time (install, compile) -> a layer.
  • COPY/ADD  : put files into the image (prefer COPY; ADD also untars/URLs).
  • CMD vs ENTRYPOINT: CMD = default command (overridable); ENTRYPOINT = fixed
    command, with CMD becoming its arguments.
  • WORKDIR, ENV, EXPOSE, ARG (build-time var), USER (run non-root).

BUILD & RUN:
  docker build -t myapp:1.0 .
  docker run -p 3000:3000 myapp:1.0

TIP: use a .dockerignore (exclude node_modules, .git) for faster builds +
smaller images. Combine RUN commands with && to reduce layers. Prefer the
ARRAY (exec) form of CMD (it receives stop signals correctly).',
'[]',-260,-640),

('n_dk_layers','Layers & Build Cache','DevOps & Cloud',
'Image gồm nhiều LAYER xếp chồng (mỗi RUN/COPY/ADD tạo một layer chỉ đọc).
Docker CACHE từng layer để build lại nhanh.

CƠ CHẾ CACHE:
  • Mỗi lệnh -> một layer. Nếu lệnh + input KHÔNG đổi -> Docker DÙNG LẠI
    layer cũ (cache hit), bỏ qua chạy lại.
  • Khi một layer đổi -> layer đó VÀ MỌI layer sau nó phải build lại
    (cache bị vô hiệu).

THỨ TỰ QUAN TRỌNG:
  ✗ COPY . .            # copy hết trước
    RUN npm ci          # đổi 1 dòng code -> phải cài lại TOÀN BỘ deps!

  ✓ COPY package*.json ./
    RUN npm ci          # layer này chỉ build lại khi package.json đổi
    COPY . .            # code đổi thường xuyên -> để CUỐI
  -> đặt thứ ÍT ĐỔI (deps) TRƯỚC, thứ HAY ĐỔI (source) SAU.

CHIA SẺ LAYER: nhiều image cùng "FROM node:20" dùng CHUNG layer nền
-> tiết kiệm ổ đĩa + pull nhanh.

XEM: docker history <image>   (liệt kê layer + kích thước)

MẸO: sắp Dockerfile theo TẦN SUẤT THAY ĐỔI để tối đa cache -> build lại chỉ
vài giây thay vì vài phút. Đây là kỹ năng tối ưu Dockerfile quan trọng nhất.',
'An image is a stack of LAYERS (each RUN/COPY/ADD makes a read-only layer).
Docker CACHES each layer to rebuild quickly.

CACHING MECHANISM:
  • Each instruction -> a layer. If the instruction + input are UNCHANGED ->
    Docker REUSES the old layer (cache hit), skipping re-execution.
  • When a layer changes -> that layer AND ALL layers after it must rebuild
    (cache invalidation).

ORDER MATTERS:
  ✗ COPY . .            # copy everything first
    RUN npm ci          # changing one code line -> reinstalls ALL deps!

  ✓ COPY package*.json ./
    RUN npm ci          # this layer rebuilds only when package.json changes
    COPY . .            # source changes often -> put it LAST
  -> put RARELY-CHANGING things (deps) FIRST, OFTEN-CHANGING (source) LAST.

LAYER SHARING: many images with "FROM node:20" SHARE the base layer
-> saves disk + faster pulls.

INSPECT: docker history <image>   (lists layers + sizes)

TIP: arrange the Dockerfile by CHANGE FREQUENCY to maximize caching ->
rebuilds take seconds not minutes. This is the most important Dockerfile
optimization skill.',
'[]',-200,-620),

('n_dk_registry','Registry & Tags','DevOps & Cloud',
'Registry là kho chứa & phân phối image (ví như "npm/GitHub cho image").
Docker Hub là registry công khai mặc định.

LUỒNG:
  build image -> tag -> push lên registry -> máy khác pull về -> run
  docker tag myapp:1.0 myuser/myapp:1.0
  docker push myuser/myapp:1.0
  docker pull myuser/myapp:1.0

TÊN IMAGE đầy đủ: [registry/]namespace/repository:tag
  nginx:1.25              (Docker Hub, official)
  ghcr.io/org/app:2.1     (GitHub Container Registry)
  1234.dkr.ecr.us-east-1.amazonaws.com/app:prod   (AWS ECR)

TAG (phiên bản):
  • tag = version (1.0, 2.1). "latest" chỉ là tag MẶC ĐỊNH, KHÔNG tự nghĩa
    là "mới nhất" -> ở production nên tag phiên bản rõ ràng.

REGISTRY phổ biến: Docker Hub, GitHub GHCR, GitLab, AWS ECR, Google
Artifact Registry.

MẸO: production ĐỪNG dùng "latest" (khó biết đang chạy bản nào, khó
rollback) -> tag theo version hoặc git SHA. Dùng registry riêng (ECR/GHCR)
+ docker login cho image nội bộ. CI/CD thường build -> push image tự động
rồi server pull về triển khai.',
'A registry stores & distributes images (think "npm/GitHub for images").
Docker Hub is the default public registry.

FLOW:
  build image -> tag -> push to a registry -> another host pulls -> run
  docker tag myapp:1.0 myuser/myapp:1.0
  docker push myuser/myapp:1.0
  docker pull myuser/myapp:1.0

FULL IMAGE NAME: [registry/]namespace/repository:tag
  nginx:1.25              (Docker Hub, official)
  ghcr.io/org/app:2.1     (GitHub Container Registry)
  1234.dkr.ecr.us-east-1.amazonaws.com/app:prod   (AWS ECR)

TAGS (versions):
  • a tag = a version (1.0, 2.1). "latest" is just the DEFAULT tag, it does
    NOT automatically mean "newest" -> in production tag explicit versions.

COMMON REGISTRIES: Docker Hub, GitHub GHCR, GitLab, AWS ECR, Google
Artifact Registry.

TIP: in production do NOT use "latest" (hard to know what is running, hard
to roll back) -> tag by version or git SHA. Use a private registry (ECR/GHCR)
+ docker login for internal images. CI/CD usually builds -> pushes images
automatically, then servers pull to deploy.',
'[]',-140,-680)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);
