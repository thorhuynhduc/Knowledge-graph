-- ===================================================================
--  TOPIC: AWS (song ngữ VI + EN, sơ đồ). File 1: cấu trúc + Core + Compute
-- ===================================================================
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_aws','AWS','DevOps & Cloud',
'Nền tảng đám mây Amazon: hạ tầng toàn cầu (Region/AZ), IAM, VPC; compute
(EC2, Lambda, container, ELB/ASG); dữ liệu (S3, RDS, DynamoDB, ElastiCache);
và vận hành (CloudFront, Route 53, CloudWatch, SQS/SNS).',
'Amazon cloud platform: global infrastructure (Region/AZ), IAM, VPC; compute
(EC2, Lambda, containers, ELB/ASG); data (S3, RDS, DynamoDB, ElastiCache);
and operations (CloudFront, Route 53, CloudWatch, SQS/SNS).',
'[]',860,0),

('s_aws_core','Nền tảng & Bảo mật','DevOps & Cloud',
'Hạ tầng toàn cầu (Region/AZ), IAM (định danh & quyền), và VPC (mạng riêng).',
'Global infrastructure (Region/AZ), IAM (identity & permissions), and VPC
(private networking).',
'[]',760,-70),
('s_aws_compute','Compute','DevOps & Cloud',
'EC2 (máy ảo), Lambda (serverless), container (ECS/EKS/Fargate), và ELB/ASG
(cân bằng tải + auto scaling).',
'EC2 (VMs), Lambda (serverless), containers (ECS/EKS/Fargate), and ELB/ASG
(load balancing + auto scaling).',
'[]',960,-70),
('s_aws_data','Lưu trữ & Dữ liệu','DevOps & Cloud',
'S3 (object storage), RDS (SQL quản lý), DynamoDB (NoSQL), ElastiCache (cache).',
'S3 (object storage), RDS (managed SQL), DynamoDB (NoSQL), ElastiCache (cache).',
'[]',760,70),
('s_aws_ops','Phân phối & Vận hành','DevOps & Cloud',
'CloudFront (CDN), Route 53 (DNS), CloudWatch (giám sát), SQS/SNS (nhắn tin).',
'CloudFront (CDN), Route 53 (DNS), CloudWatch (monitoring), SQS/SNS (messaging).',
'[]',960,70),

-- ------------------------- CORE -----------------------------------
('n_aws_global','Region, AZ & Edge','DevOps & Cloud',
'AWS chia hạ tầng toàn cầu thành REGION và AVAILABILITY ZONE (AZ) để chịu
lỗi và đặt gần người dùng.

  • Region: một vùng địa lý (us-east-1, ap-southeast-1 = Singapore). Mỗi
    region ĐỘC LẬP; chọn theo: gần user (latency), giá, dịch vụ sẵn có,
    tuân thủ dữ liệu.
  • Availability Zone (AZ): một hoặc nhiều trung tâm dữ liệu TÁCH BIỆT trong
    một region (điện/mạng riêng). Mỗi region có 2-6 AZ (us-east-1a, 1b, 1c).
  • Edge Location: điểm CDN (CloudFront) ở rất nhiều nơi, gần user hơn cả region.

THIẾT KẾ HA (high availability):
  Triển khai qua NHIỀU AZ -> một AZ sập vẫn còn AZ khác.
  [Region ap-southeast-1]
    AZ-a: server + DB primary
    AZ-b: server + DB standby     <- Load Balancer trải request qua cả hai

MẸO: chọn region gần người dùng nhất (VN -> Singapore ap-southeast-1). LUÔN
chạy production trên >= 2 AZ để chịu lỗi. Region ảnh hưởng giá + dịch vụ
(dịch vụ mới thường ra us-east-1 trước). Dữ liệu KHÔNG tự nhân bản giữa các
region (phải tự cấu hình).',
'AWS divides its global infrastructure into REGIONS and AVAILABILITY ZONES
(AZs) for fault tolerance and proximity to users.

  • Region: a geographic area (us-east-1, ap-southeast-1 = Singapore). Each
    region is INDEPENDENT; choose by: nearness to users (latency), price,
    available services, data compliance.
  • Availability Zone (AZ): one or more ISOLATED data centers within a region
    (separate power/network). Each region has 2-6 AZs (us-east-1a, 1b, 1c).
  • Edge Location: CDN points (CloudFront) in many places, closer than a region.

HA DESIGN (high availability):
  Deploy across MULTIPLE AZs -> one AZ fails, others remain.
  [Region ap-southeast-1]
    AZ-a: server + DB primary
    AZ-b: server + DB standby     <- a Load Balancer spreads requests across both

TIP: pick the region nearest your users (VN -> Singapore ap-southeast-1).
ALWAYS run production across >= 2 AZs for fault tolerance. Region affects
price + services (new services often launch in us-east-1 first). Data does
NOT auto-replicate across regions (you must configure it).',
'[]',700,-110),

('n_aws_iam','IAM (Identity & Access)','DevOps & Cloud',
'IAM (Identity and Access Management) quản lý AI được làm GÌ trên tài nguyên
AWS. Nền tảng bảo mật của mọi thứ trên AWS.

THÀNH PHẦN:
  • User   : danh tính con người/ứng dụng (có credentials).
  • Group  : nhóm user chia sẻ quyền.
  • Role   : danh tính TẠM cấp quyền, không mật khẩu cố định — dịch vụ/EC2/
    Lambda "nhận vai" để lấy quyền tạm thời.
  • Policy : tài liệu JSON định nghĩa quyền (Allow/Deny action trên resource).

POLICY (ví dụ — cho đọc một bucket S3):
  { "Effect": "Allow",
    "Action": ["s3:GetObject"],
    "Resource": "arn:aws:s3:::my-bucket/*" }

NGUYÊN TẮC:
  • Least privilege: cấp quyền TỐI THIỂU cần thiết, đừng dùng "*" bừa bãi.
  • Dùng ROLE cho ứng dụng/dịch vụ (vd EC2 role) thay vì nhét access key vào code.
  • Bật MFA cho user; KHÔNG dùng tài khoản root hằng ngày.

MẸO: EC2/Lambda gắn ROLE -> tự có quyền gọi AWS API mà không cần lưu key
(an toàn nhất). IAM cấu hình sai là nguyên nhân rò rỉ dữ liệu hàng đầu ->
luôn least privilege. ARN là "địa chỉ" định danh mọi tài nguyên AWS.',
'IAM (Identity and Access Management) governs WHO can do WHAT on AWS
resources. The security foundation of everything on AWS.

COMPONENTS:
  • User   : a human/app identity (has credentials).
  • Group  : a set of users sharing permissions.
  • Role   : a TEMPORARY identity granting permissions, no fixed password -
    services/EC2/Lambda "assume the role" to get temporary permissions.
  • Policy : a JSON document defining permissions (Allow/Deny actions on resources).

POLICY (example - read one S3 bucket):
  { "Effect": "Allow",
    "Action": ["s3:GetObject"],
    "Resource": "arn:aws:s3:::my-bucket/*" }

PRINCIPLES:
  • Least privilege: grant the MINIMUM needed, do not use "*" carelessly.
  • Use ROLES for apps/services (e.g. an EC2 role) instead of baking access
    keys into code.
  • Enable MFA for users; do NOT use the root account for daily work.

TIP: attach a ROLE to EC2/Lambda -> it can call AWS APIs without stored keys
(the safest way). Misconfigured IAM is a top cause of data leaks -> always
least privilege. An ARN is the "address" identifying every AWS resource.',
'[]',740,-30),

('n_aws_vpc','VPC (Mạng riêng)','DevOps & Cloud',
'VPC (Virtual Private Cloud) là mạng ảo RIÊNG của bạn trên AWS — bạn kiểm
soát dải IP, subnet, định tuyến, firewall. Mọi tài nguyên (EC2, RDS) nằm
trong một VPC.

CẤU TRÚC:
  VPC 10.0.0.0/16
    ├─ Public subnet  10.0.1.0/24  -> có route ra Internet (qua Internet Gateway)
    │     (web server, load balancer, bastion)
    └─ Private subnet 10.0.2.0/24  -> KHÔNG ra Internet trực tiếp
          (DB, app nội bộ) — ra ngoài qua NAT Gateway

THÀNH PHẦN:
  • Subnet: chia VPC theo AZ; public (ra Internet) vs private (kín).
  • Internet Gateway (IGW): cổng cho public subnet ra Internet.
  • NAT Gateway: cho private subnet GỌI RA ngoài (update, API) mà không bị
    gọi vào.
  • Route table: định tuyến giữa subnet/gateway.
  • Security Group: firewall mức instance (stateful).
  • NACL: firewall mức subnet (stateless).

MẪU KINH ĐIỂN: web ở PUBLIC subnet, DB ở PRIVATE subnet (chỉ web mới gọi
được DB) -> DB không lộ ra Internet.

MẸO: đặt DB/backend ở PRIVATE subnet, chỉ để public những gì cần (LB/web).
Security Group là hàng rào chính (mở port tối thiểu). VPC + subnet là kiến
thức nền cho mọi kiến trúc AWS an toàn.',
'A VPC (Virtual Private Cloud) is your own PRIVATE virtual network on AWS -
you control the IP range, subnets, routing, firewalls. Every resource (EC2,
RDS) lives inside a VPC.

STRUCTURE:
  VPC 10.0.0.0/16
    ├─ Public subnet  10.0.1.0/24  -> has a route to the Internet (via an Internet Gateway)
    │     (web servers, load balancer, bastion)
    └─ Private subnet 10.0.2.0/24  -> NO direct Internet access
          (DBs, internal apps) — outbound via a NAT Gateway

COMPONENTS:
  • Subnet: split the VPC per AZ; public (Internet-facing) vs private (closed).
  • Internet Gateway (IGW): the gate for a public subnet to reach the Internet.
  • NAT Gateway: lets a private subnet call OUT (updates, APIs) without being
    reachable IN.
  • Route table: routing between subnets/gateways.
  • Security Group: instance-level firewall (stateful).
  • NACL: subnet-level firewall (stateless).

CLASSIC PATTERN: web in a PUBLIC subnet, DB in a PRIVATE subnet (only the web
can reach the DB) -> the DB is not exposed to the Internet.

TIP: put DBs/backends in PRIVATE subnets, expose only what is needed (LB/web).
Security Groups are the main barrier (open minimal ports). VPC + subnets are
foundational for every secure AWS architecture.',
'[]',780,-30),

-- ------------------------- COMPUTE --------------------------------
('n_aws_ec2','EC2 (Máy ảo)','DevOps & Cloud',
'EC2 (Elastic Compute Cloud) là MÁY CHỦ ẢO thuê theo nhu cầu — nền tảng
compute cổ điển của AWS (như một VM bạn toàn quyền quản).

KHÁI NIỆM:
  • Instance : một máy ảo đang chạy; chọn INSTANCE TYPE (t3.micro, m5.large)
    = CPU/RAM/mạng.
  • AMI      : ảnh OS + phần mềm để khởi tạo instance.
  • EBS      : ổ đĩa mạng bền gắn vào instance (dữ liệu còn khi stop).
  • Key pair : SSH vào instance;  Security Group: firewall.

GIÁ (pricing):
  • On-Demand : trả theo giờ/giây, linh hoạt, đắt nhất.
  • Reserved / Savings Plan: cam kết 1-3 năm -> rẻ hơn nhiều (tải ổn định).
  • Spot: dùng dung lượng thừa, rẻ tới 90% nhưng có thể bị thu hồi (tải
    chịu gián đoạn được).

KHI NÀO DÙNG: cần toàn quyền OS, phần mềm đặc thù, hoặc app chạy thường trực.
Không muốn quản server -> Lambda/container.

MẸO: chọn instance type vừa đủ rồi giám sát & chỉnh (right-sizing). Tải ổn
định -> Reserved/Savings để tiết kiệm; job chịu gián đoạn -> Spot. Gắn IAM
Role thay vì lưu access key. Đặt sau load balancer + auto-scaling cho HA.',
'EC2 (Elastic Compute Cloud) is an on-demand VIRTUAL SERVER - AWS classic
compute (like a VM you fully control).

CONCEPTS:
  • Instance : a running VM; pick an INSTANCE TYPE (t3.micro, m5.large) =
    CPU/RAM/network.
  • AMI      : an OS + software image to launch instances from.
  • EBS      : durable network disk attached to an instance (data survives stop).
  • Key pair : SSH into an instance;  Security Group: firewall.

PRICING:
  • On-Demand : per hour/second, flexible, most expensive.
  • Reserved / Savings Plan: 1-3 year commitment -> much cheaper (steady load).
  • Spot: uses spare capacity, up to 90% cheaper but can be reclaimed
    (for interruption-tolerant work).

WHEN TO USE: you need full OS control, special software, or a long-running
app. Do not want to manage servers -> Lambda/containers.

TIP: pick a just-enough instance type, then monitor & adjust (right-sizing).
Steady load -> Reserved/Savings to save; interruptible jobs -> Spot. Attach
an IAM Role instead of storing access keys. Place behind a load balancer +
auto-scaling for HA.',
'[]',920,-110),

('n_aws_lambda','Lambda (Serverless)','DevOps & Cloud',
'Lambda là SERVERLESS compute: bạn chỉ tải lên HÀM, AWS lo chạy + scale,
KHÔNG quản server. Trả tiền theo số lần gọi + thời gian chạy (mili-giây).

MÔ HÌNH:
  Sự kiện (HTTP qua API Gateway, file lên S3, message SQS, cron...) ->
  Lambda chạy hàm -> trả kết quả -> tắt.
  event -> [Lambda] -> result   (tự scale: 1 hay 10.000 request đồng thời)

ĐẶC ĐIỂM:
  • Không có server để quản/patch; tự scale về 0 khi rảnh (không gọi ->
    không tốn tiền).
  • Giới hạn: thời gian chạy tối đa 15 phút, dung lượng; COLD START (lần gọi
    đầu chậm hơn do khởi tạo môi trường).
  • Stateless: không giữ state giữa các lần gọi -> để state ở DB/S3.

KHI NÀO DÙNG: API nhẹ, xử lý sự kiện (resize ảnh khi upload S3), cron job,
"glue" giữa các dịch vụ, tải BIẾN ĐỘNG mạnh (lúc nhiều lúc không).
KHÔNG HỢP: chạy lâu/liên tục, tải nặng ổn định (EC2/container rẻ hơn), cần
độ trễ cực thấp ổn định (vướng cold start).

MẸO: serverless = trả theo dùng thật + hết lo scale/server. Hợp workload
rời rạc/biến động. Giảm cold start bằng provisioned concurrency. API Gateway
+ Lambda + DynamoDB là kiến trúc serverless kinh điển.',
'Lambda is SERVERLESS compute: you upload only a FUNCTION, AWS runs & scales
it, with NO servers to manage. Pay per invocation + run time (milliseconds).

MODEL:
  An event (HTTP via API Gateway, an S3 upload, an SQS message, cron...) ->
  Lambda runs the function -> returns a result -> shuts down.
  event -> [Lambda] -> result   (auto-scales: 1 or 10,000 concurrent requests)

CHARACTERISTICS:
  • No servers to manage/patch; scales to zero when idle (no calls -> no cost).
  • Limits: max 15-minute runtime, size limits; COLD START (the first call is
    slower due to environment init).
  • Stateless: keeps no state between calls -> put state in a DB/S3.

WHEN TO USE: light APIs, event processing (resize an image on S3 upload),
cron jobs, "glue" between services, highly VARIABLE load (bursty).
NOT SUITED: long/continuous runs, steady heavy load (EC2/containers are
cheaper), needing consistently ultra-low latency (cold starts).

TIP: serverless = pay for actual use + no scaling/server worries. Good for
sporadic/variable workloads. Reduce cold starts with provisioned concurrency.
API Gateway + Lambda + DynamoDB is the classic serverless architecture.',
'[]',1000,-30),

('n_aws_containers','Container (ECS/EKS/Fargate)','DevOps & Cloud',
'Chạy container (Docker) trên AWS có nhiều lựa chọn, khác nhau ở mức "phải
quản bao nhiêu":
  • ECS (Elastic Container Service): orchestrator container riêng của AWS,
    đơn giản, tích hợp sâu với AWS.
  • EKS (Elastic Kubernetes Service): Kubernetes được quản lý — hợp nếu đã
    dùng/muốn chuẩn K8s (đa cloud).
  • Fargate: chế độ SERVERLESS cho ECS/EKS — KHÔNG quản EC2 nền, chỉ khai
    báo CPU/RAM cho task, AWS lo hạ tầng.
  • ECR (Elastic Container Registry): kho image Docker riêng (push/pull).

SO SÁNH lựa chọn:
  ECS + EC2     : bạn quản cụm EC2 nền (rẻ hơn khi tải lớn, nhiều việc hơn).
  ECS + Fargate : không quản server, trả theo task (đơn giản nhất).
  EKS           : cần Kubernetes (phức tạp hơn, chuẩn mở, đa cloud).

LUỒNG: build image -> push lên ECR -> ECS/EKS kéo về chạy task -> đặt sau ALB.

MẸO: mới/nhỏ và ở trong AWS -> ECS + Fargate (ít việc vận hành nhất). Đã
theo Kubernetes / cần đa cloud -> EKS. Cần kiểm soát & tối ưu chi phí ở tải
lớn -> ECS/EKS trên EC2. Luôn dùng ECR cho image nội bộ. Liên hệ topic Docker.',
'Running containers (Docker) on AWS has several options, differing in "how
much you manage":
  • ECS (Elastic Container Service): AWS own container orchestrator, simple,
    deeply integrated with AWS.
  • EKS (Elastic Kubernetes Service): managed Kubernetes - good if you already
    use/want the K8s standard (multi-cloud).
  • Fargate: a SERVERLESS mode for ECS/EKS - NO underlying EC2 to manage, you
    just declare CPU/RAM per task, AWS handles infrastructure.
  • ECR (Elastic Container Registry): a private Docker image registry (push/pull).

COMPARISON:
  ECS + EC2     : you manage the underlying EC2 cluster (cheaper at scale, more work).
  ECS + Fargate : no servers to manage, pay per task (simplest).
  EKS           : requires Kubernetes (more complex, open standard, multi-cloud).

FLOW: build image -> push to ECR -> ECS/EKS pulls & runs tasks -> place behind an ALB.

TIP: new/small and inside AWS -> ECS + Fargate (least ops). Already on
Kubernetes / need multi-cloud -> EKS. Need control & cost optimization at
scale -> ECS/EKS on EC2. Always use ECR for internal images. See the Docker topic.',
'[]',1040,-10),

('n_aws_scaling','ELB & Auto Scaling','DevOps & Cloud',
'Hai dịch vụ giúp app CHỊU TẢI và TỰ CO GIÃN:

ELB (Elastic Load Balancing) — phân phối request tới nhiều instance:
  • ALB (Application LB, L7): định tuyến HTTP theo path/host, hợp web/API/
    microservice.
  • NLB (Network LB, L4): cực nhanh, theo TCP/UDP, tải rất lớn.
  ELB + health check -> ngừng gửi tới instance hỏng.

ASG (Auto Scaling Group) — tự thêm/bớt EC2 theo tải:
  • Đặt min / desired / max số instance.
  • Scaling policy: theo CPU (>70% -> thêm máy), theo lịch, hoặc theo metric.
  • Tự thay instance chết (self-healing).

KẾT HỢP KINH ĐIỂN:
  Users -> ALB -> [ ASG: 2..10 EC2 qua nhiều AZ ] -> DB
  tải tăng -> ASG thêm EC2, ALB trải đều; tải giảm -> bớt EC2 (tiết kiệm tiền).

MẸO: ALB + ASG qua nhiều AZ = mẫu HA + scale ngang chuẩn của AWS. Muốn
scale mượt, instance phải STATELESS (đẩy state sang RDS/DynamoDB/ElastiCache).
Scale theo metric phù hợp (CPU, số request) thay vì đoán mò.',
'Two services that let an app HANDLE LOAD and AUTO-SCALE:

ELB (Elastic Load Balancing) - distributes requests across instances:
  • ALB (Application LB, L7): HTTP routing by path/host, good for web/API/
    microservices.
  • NLB (Network LB, L4): very fast, by TCP/UDP, huge throughput.
  ELB + health checks -> stop sending to unhealthy instances.

ASG (Auto Scaling Group) - automatically adds/removes EC2 by load:
  • Set min / desired / max instance counts.
  • Scaling policy: by CPU (>70% -> add), by schedule, or by a metric.
  • Auto-replaces dead instances (self-healing).

CLASSIC COMBO:
  Users -> ALB -> [ ASG: 2..10 EC2 across AZs ] -> DB
  load rises -> ASG adds EC2, ALB spreads it; load falls -> remove EC2 (save money).

TIP: ALB + ASG across multiple AZs = the standard AWS HA + horizontal-scaling
pattern. For smooth scaling, instances must be STATELESS (push state to
RDS/DynamoDB/ElastiCache). Scale by a suitable metric (CPU, request count)
instead of guessing.',
'[]',980,-110)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);
