-- TOPIC Docker file 2: Run & Ops
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('n_dk_volumes','Volumes (lưu dữ liệu)','DevOps & Cloud',
'Container "ephemeral" — xóa là mất dữ liệu ghi bên trong. VOLUME giúp lưu
dữ liệu BỀN, tồn tại ngoài vòng đời container.

BA CÁCH GẮN DỮ LIỆU:
  1. Named volume (Docker quản lý, khuyên cho DB):
     docker volume create dbdata
     docker run -v dbdata:/var/lib/mysql mysql
  2. Bind mount (map thư mục HOST vào container, hợp DEV):
     docker run -v "$(pwd)":/app node   # sửa code trên host -> thấy ngay trong container
  3. tmpfs: chỉ nằm trong RAM, mất khi dừng.

VÍ DỤ: DB lưu vào named volume -> xóa & tạo lại container DB, dữ liệu VẪN CÒN.

XEM: docker volume ls / inspect / rm

KHÁC BIỆT:
  • named volume: Docker lưu ở vùng riêng, di động, tốt cho production (DB).
  • bind mount  : gắn đường dẫn thật trên host, tốt cho dev (hot reload)
    nhưng phụ thuộc cấu trúc máy.

MẸO: dữ liệu cần bền (DB, file upload) -> luôn dùng volume. ĐỪNG lưu state
quan trọng trong lớp ghi của container. Trong Compose, khai báo mục volumes:
cho gọn và tự quản lý.',
'Containers are "ephemeral" - removing one loses the data written inside. A
VOLUME persists data beyond a container lifetime.

THREE WAYS TO MOUNT DATA:
  1. Named volume (Docker-managed, recommended for DBs):
     docker volume create dbdata
     docker run -v dbdata:/var/lib/mysql mysql
  2. Bind mount (map a HOST directory into the container, good for DEV):
     docker run -v "$(pwd)":/app node   # edit code on host -> seen instantly inside
  3. tmpfs: lives only in RAM, lost on stop.

EXAMPLE: store a DB in a named volume -> remove & recreate the DB container,
the data REMAINS.

INSPECT: docker volume ls / inspect / rm

DIFFERENCES:
  • named volume: Docker stores it in a managed area, portable, good for
    production (DBs).
  • bind mount  : mounts a real host path, good for dev (hot reload) but
    depends on the machine layout.

TIP: for data that must persist (DBs, uploads) always use a volume. Do NOT
keep important state in the container writable layer. In Compose, declare a
volumes: section for convenience and management.',
'[]',180,-700),

('n_dk_networks','Networks','DevOps & Cloud',
'Docker tạo mạng ảo để các container GIAO TIẾP với nhau và ra ngoài. Mặc
định mỗi container có một IP nội bộ.

LOẠI NETWORK:
  • bridge (mặc định): mạng riêng trên host.
  • host: dùng thẳng mạng của host (không cách ly cổng).
  • none: không có mạng.

DNS NỘI BỘ (rất quan trọng): trong một user-defined bridge network, các
container gọi nhau bằng TÊN (service/container) thay vì IP:
  docker network create appnet
  docker run --network appnet --name db  mysql
  docker run --network appnet --name api myapi
  # trong "api", kết nối tới host "db:3306" -> Docker tự phân giải tên "db"

-> đây chính là lý do trong docker-compose bạn dùng "mysql" (tên service)
   làm hostname của DB.

XEM: docker network ls / inspect

MẸO: đặt các service liên quan vào CÙNG một network để gọi nhau bằng TÊN
(không hardcode IP — IP container thay đổi mỗi lần tạo lại). Compose tự tạo
sẵn một network chung cho mọi service khai trong file.',
'Docker creates virtual networks so containers can COMMUNICATE with each
other and the outside. By default each container has an internal IP.

NETWORK TYPES:
  • bridge (default): a private network on the host.
  • host: use the host network directly (no port isolation).
  • none: no network.

INTERNAL DNS (very important): in a user-defined bridge network, containers
reach each other by NAME (service/container) instead of IP:
  docker network create appnet
  docker run --network appnet --name db  mysql
  docker run --network appnet --name api myapi
  # inside "api", connect to host "db:3306" -> Docker resolves the name "db"

-> this is exactly why in docker-compose you use "mysql" (the service name)
   as the DB hostname.

INSPECT: docker network ls / inspect

TIP: put related services on the SAME network to reach each other by NAME
(do not hardcode IPs - container IPs change on recreation). Compose
auto-creates a shared network for all services declared in the file.',
'[]',220,-640),

('n_dk_ports_env','Ports & Environment','DevOps & Cloud',
'PORT MAPPING đưa cổng trong container ra ngoài host (mặc định cổng
container bị cô lập):
  docker run -p 8080:80 nginx     # host:8080 -> container:80
  -> truy cập http://localhost:8080. Không map thì bên ngoài KHÔNG tới được.
  cú pháp -p HOST:CONTAINER (nhớ thứ tự: host trước).

ENVIRONMENT VARIABLES cấu hình app (không hardcode vào image):
  docker run -e NODE_ENV=production -e DB_HOST=db myapi
  docker run --env-file .env myapi         # nạp từ file
  # trong Dockerfile: ENV KEY=value (giá trị mặc định)

12-FACTOR: cấu hình qua ENV -> CÙNG một image chạy được dev/staging/prod
chỉ bằng đổi biến, KHÔNG rebuild.

BÍ MẬT (secrets): đừng nhét mật khẩu/key vào image hay Dockerfile (ai pull
image cũng đọc được). Dùng ENV lúc chạy, Docker secrets, hoặc secret
manager (Vault, AWS Secrets Manager).

MẸO: image nên "không biết" mình chạy ở môi trường nào; mọi khác biệt (DB
host, API key) truyền qua ENV lúc run. Dùng -p để lộ cổng ra ngoài; giao
tiếp container-to-container nội bộ KHÔNG cần -p (dùng network + tên).',
'PORT MAPPING exposes a container port to the host (container ports are
isolated by default):
  docker run -p 8080:80 nginx     # host:8080 -> container:80
  -> visit http://localhost:8080. Without mapping, the outside CANNOT reach it.
  syntax -p HOST:CONTAINER (order matters: host first).

ENVIRONMENT VARIABLES configure the app (do not hardcode into the image):
  docker run -e NODE_ENV=production -e DB_HOST=db myapi
  docker run --env-file .env myapi         # load from a file
  # in the Dockerfile: ENV KEY=value (a default value)

12-FACTOR: configure via ENV -> the SAME image runs in dev/staging/prod just
by changing variables, with NO rebuild.

SECRETS: do not put passwords/keys into the image or Dockerfile (anyone who
pulls the image can read them). Use runtime ENV, Docker secrets, or a secret
manager (Vault, AWS Secrets Manager).

TIP: an image should be "unaware" of its environment; pass all differences
(DB host, API key) via ENV at run time. Use -p to expose ports outward;
internal container-to-container traffic needs NO -p (use a network + names).',
'[]',260,-680),

('n_dk_compose','Docker Compose','DevOps & Cloud',
'Docker Compose định nghĩa & chạy ứng dụng NHIỀU container bằng một file
YAML (docker-compose.yml) -> một lệnh dựng cả hệ.

  services:
    api:
      build: .                    # build từ Dockerfile trong thư mục
      ports: ["3000:3000"]
      environment:
        DB_HOST: db               # gọi service "db" bằng tên
      depends_on: [db]
    db:
      image: mysql:8.0
      environment:
        MYSQL_ROOT_PASSWORD: secret
      volumes: ["dbdata:/var/lib/mysql"]   # lưu bền
  volumes:
    dbdata:

LỆNH:
  docker compose up -d          # dựng & chạy nền tất cả service
  docker compose down           # dừng & xóa (down -v: xóa cả volume)
  docker compose logs -f api    # xem log service api
  docker compose ps / exec api sh

ƯU ĐIỂM: các service cùng file tự nằm CHUNG network -> gọi nhau bằng tên
(api tới "db:3306"). Khai báo volume, env, port, phụ thuộc ở MỘT chỗ.

MẸO: Compose tuyệt cho DEV và app nhỏ/vừa (như chính app Knowledge Graph
này). Quy mô lớn / HA -> Kubernetes. Lưu ý "depends_on" chỉ đợi container
KHỞI ĐỘNG, không đợi DB SẴN SÀNG nhận kết nối -> cần healthcheck hoặc retry
trong app.',
'Docker Compose defines & runs a MULTI-container app from one YAML file
(docker-compose.yml) -> one command brings up the whole stack.

  services:
    api:
      build: .                    # build from the Dockerfile in this folder
      ports: ["3000:3000"]
      environment:
        DB_HOST: db               # reach service "db" by name
      depends_on: [db]
    db:
      image: mysql:8.0
      environment:
        MYSQL_ROOT_PASSWORD: secret
      volumes: ["dbdata:/var/lib/mysql"]   # persist
  volumes:
    dbdata:

COMMANDS:
  docker compose up -d          # build & run all services in background
  docker compose down           # stop & remove (down -v: also remove volumes)
  docker compose logs -f api    # view the api service logs
  docker compose ps / exec api sh

BENEFITS: services in one file auto-share a network -> reach each other by
name (api to "db:3306"). Declare volumes, env, ports, dependencies in ONE
place.

TIP: Compose is great for DEV and small/medium apps (like this Knowledge
Graph app itself). Large scale / HA -> Kubernetes. Note "depends_on" only
waits for the container to START, not for the DB to be READY for connections
-> use a healthcheck or retry in the app.',
'[]',160,-620),

-- ------------------------- OPS ------------------------------------
('n_dk_multistage','Multi-stage Build','DevOps & Cloud',
'Multi-stage build dùng NHIỀU FROM trong một Dockerfile: một stage để BUILD
(đầy đủ công cụ), rồi copy CHỈ kết quả sang stage RUN gọn nhẹ -> image cuối
nhỏ, không chứa toolchain.

  # ---- stage build ----
  FROM node:20 AS build
  WORKDIR /app
  COPY package*.json ./
  RUN npm ci
  COPY . .
  RUN npm run build              # tạo /app/dist

  # ---- stage runtime ----
  FROM nginx:alpine
  COPY --from=build /app/dist /usr/share/nginx/html
  # image cuối CHỈ có nginx + dist, KHÔNG có node_modules/toolchain

LỢI ÍCH:
  • Image nhỏ hơn nhiều (bỏ devDependencies, compiler, source code).
  • An toàn hơn (ít thứ thừa -> ít bề mặt tấn công).
  • Vẫn một Dockerfile, một lệnh build duy nhất.

VÍ DỤ Go/Java: stage build biên dịch ra binary/jar -> stage runtime chỉ
copy binary vào một image tối giản (alpine/distroless).

MẸO: dùng multi-stage cho MỌI app cần bước build (JS bundling, biên dịch
Go/Java/Rust). Kết hợp base image nhỏ (alpine, distroless) -> image từ hàng
trăm MB có thể xuống còn vài chục MB.',
'A multi-stage build uses MULTIPLE FROM lines in one Dockerfile: a BUILD
stage (full tooling), then copies ONLY the output into a lean RUN stage ->
the final image is small and contains no toolchain.

  # ---- build stage ----
  FROM node:20 AS build
  WORKDIR /app
  COPY package*.json ./
  RUN npm ci
  COPY . .
  RUN npm run build              # produces /app/dist

  # ---- runtime stage ----
  FROM nginx:alpine
  COPY --from=build /app/dist /usr/share/nginx/html
  # the final image has ONLY nginx + dist, NO node_modules/toolchain

BENEFITS:
  • Much smaller image (drops devDependencies, compiler, source code).
  • Safer (less cruft -> smaller attack surface).
  • Still one Dockerfile, one build command.

Go/Java EXAMPLE: the build stage compiles a binary/jar -> the runtime stage
just copies the binary into a minimal image (alpine/distroless).

TIP: use multi-stage for EVERY app with a build step (JS bundling, Go/Java/
Rust compilation). Combined with a small base image (alpine, distroless), an
image can shrink from hundreds of MB to tens of MB.',
'[]',-60,-760),

('n_dk_bestpractice','Best Practices (nhỏ, an toàn)','DevOps & Cloud',
'Thực hành tốt để image NHỎ, NHANH, AN TOÀN:

KÍCH THƯỚC:
  • Base nhỏ: alpine / slim / distroless thay cho image full-OS.
  • Multi-stage build (bỏ toolchain khỏi image cuối).
  • .dockerignore (bỏ node_modules, .git, file test).
  • Gộp RUN + dọn cache trong CÙNG layer:
    RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

CACHE / TỐC ĐỘ:
  • Copy file phụ thuộc TRƯỚC, source SAU (tận dụng cache).
  • Pin phiên bản base (node:20.11 thay vì node:latest) -> build ổn định,
    lặp lại được.

BẢO MẬT:
  • Chạy non-root: thêm USER node (đừng để tiến trình chạy bằng root).
  • Đừng nhồi secret vào image.
  • Quét lỗ hổng: docker scout, trivy.

VẬN HÀNH:
  • MỘT tiến trình chính mỗi container (đừng nhồi nhiều service vào một).
  • Ghi log ra stdout/stderr (Docker tự thu thập).

MẸO: mục tiêu = "image nhỏ + cache tốt + non-root + không secret". Ba đòn
bẩy giảm size lớn nhất: base image nhỏ, multi-stage, và .dockerignore.',
'Best practices for SMALL, FAST, SAFE images:

SIZE:
  • Small base: alpine / slim / distroless instead of a full-OS image.
  • Multi-stage build (keep toolchain out of the final image).
  • .dockerignore (exclude node_modules, .git, test files).
  • Combine RUN + cache cleanup in the SAME layer:
    RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

CACHE / SPEED:
  • Copy dependency files FIRST, source LAST (leverage the cache).
  • Pin the base version (node:20.11 not node:latest) -> stable, reproducible
    builds.

SECURITY:
  • Run non-root: add a USER node (do not run the process as root).
  • Do not bake secrets into the image.
  • Scan for vulnerabilities: docker scout, trivy.

OPERATIONS:
  • ONE main process per container (do not cram many services into one).
  • Log to stdout/stderr (Docker collects it).

TIP: the goal = "small image + good cache + non-root + no secrets". The three
biggest size levers: a small base image, multi-stage builds, and
.dockerignore.',
'[]',60,-760),

('n_dk_ops','Vận hành & Gỡ lỗi','DevOps & Cloud',
'Vận hành & gỡ lỗi container:

XEM & GỠ LỖI:
  docker logs -f <id>          # log (app nên ghi ra stdout/stderr)
  docker exec -it <id> sh      # vào shell điều tra bên trong
  docker inspect <id>          # cấu hình chi tiết (mount, network, env)
  docker stats                 # CPU/RAM realtime

HEALTHCHECK — Docker tự kiểm tra container còn "khỏe":
  HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:3000/healthz || exit 1
  -> trạng thái healthy/unhealthy; orchestrator dựa vào đó để restart/định tuyến.

RESTART POLICY:
  docker run --restart unless-stopped ...   # tự chạy lại khi crash/reboot

GIỚI HẠN TÀI NGUYÊN:
  docker run --memory=512m --cpus=1 ...     # tránh 1 container ăn hết máy

DỌN DẸP:
  docker system prune -a       # xóa image/container/network không dùng
                               # (giải phóng ổ đĩa)

MẸO: log ra stdout (đừng ghi file trong container). Đặt healthcheck để hệ
thống tự phát hiện & thay container hỏng. Giới hạn RAM/CPU ở production.
"docker system prune" cứu ổ đĩa bị đầy vì image/layer cũ.',
'Operating & debugging containers:

VIEW & DEBUG:
  docker logs -f <id>          # logs (apps should write to stdout/stderr)
  docker exec -it <id> sh      # open a shell to investigate inside
  docker inspect <id>          # detailed config (mounts, network, env)
  docker stats                 # realtime CPU/RAM

HEALTHCHECK - Docker checks whether a container is "healthy":
  HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:3000/healthz || exit 1
  -> a healthy/unhealthy status; orchestrators use it to restart/route.

RESTART POLICY:
  docker run --restart unless-stopped ...   # auto-restart on crash/reboot

RESOURCE LIMITS:
  docker run --memory=512m --cpus=1 ...     # stop one container eating the host

CLEANUP:
  docker system prune -a       # remove unused images/containers/networks
                               # (free disk space)

TIP: log to stdout (do not write files in the container). Add a healthcheck
so the system auto-detects & replaces broken containers. Limit RAM/CPU in
production. "docker system prune" rescues a disk filled by old images/layers.',
'[]',0,-800)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);
