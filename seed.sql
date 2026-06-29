-- Q&A đầy đủ trích từ interview.docx (giữ nguyên văn + IPA). Run AFTER schema.sql.
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS=0;
DELETE FROM kg_edges;
DELETE FROM kg_nodes;
SET FOREIGN_KEY_CHECKS=1;

INSERT INTO kg_nodes (id,label,category,description,links,pos_x,pos_y) VALUES
('root','Senior Full-Stack Interview','Architecture','Ngân hàng câu hỏi & câu trả lời phỏng vấn (Node.js, NestJS, React, About Me). Click một node câu hỏi để xem câu trả lời đầy đủ kèm IPA.','[]',950,950),
('t_nodejs','Node.js','Backend','','[]',500,500),
('t_nestjs','NestJS','Backend','','[]',1400,500),
('t_react','React','Frontend','','[]',500,1400),
('t_about','About Me','Behavioral','','[]',1400,1400),
('s_1','JavaScript & Node.js Core','Backend','','[]',420,639),
('s_2','Backend Architecture & Design','Backend','','[]',371,594),
('s_3','Databases & Data','Database','','[]',343,533),
('s_4','System Design & Scalability','System Design','','[]',343,467),
('s_5','Testing, DevOps & Best Practices','DevOps & Cloud','','[]',371,406),
('s_6','Front-end & Full-Stack','Frontend','','[]',420,361),
('s_7','Behavioral & Situational Questions','Behavioral','','[]',483,341),
('s_8','Basic & Core Concepts','Backend','','[]',1449,348),
('s_9','Decorators & Core Features','Backend','','[]',1507,381),
('s_10','Advanced Architecture','Architecture','','[]',1546,435),
('s_11','Performance & Scalability','System Design','','[]',1560,500),
('s_12','Testing & Quality','Backend','','[]',1546,565),
('s_13','Security & Authentication','DevOps & Cloud','','[]',1507,619),
('s_14','Deployment & DevOps','DevOps & Cloud','','[]',1449,652),
('s_15','Scenario Questions (Typical Senior Answers)','Backend','','[]',1383,659),
('s_16','Core Concepts & Fundamentals','Frontend','','[]',420,1539),
('s_17','Advanced React','Frontend','','[]',371,1494),
('s_18','State Management','Frontend','','[]',343,1433),
('s_19','Architecture & Best Practices','Frontend','','[]',343,1367),
('s_20','Advanced & System Design','Frontend','','[]',371,1306),
('q_1','Explain the event loop in Node.js.','Backend','The event loop is the heart of Node.js that allows it to be non-blocking and handle many operations ( apəˈreɪʃənz ) concurrently. It has several phases (/feɪz/) such as timers, pending callbacks, poll (/poʊl/), check, and close callbacks. When we execute asynchronous (eɪˈsɪŋkrənəs ) code like file reading or API calls, Node offloads (/ˈɑːf.loʊd/) them to the Liibuv library. Once completed, the callbacks are pushed back into the event loop. In my projects, I mostly use async/await for readability, but I am careful with process.nextTick and use setImmediate for heavy computations to avoid blocking the loop.','[]',340,223),
('q_2','What are closures? Give an example.','Backend','Closures are functions that remember the variables  from their outer scope even after the outer function has finished executing. This is very useful for data encapsulation (/ɪnˌkæp.sjəˈleɪ.ʃən/). For example, I used closures to create individual ( /ˌɪn.dəˈvɪdʒ.u.əl/ ) rate limiters for each user IP in a middleware. It helped keep the code clean and avoid using global variables.','[]',467,182),
('q_3','async/await vs Promises.','Backend','Async/await is syntactic (/sɪnˈtæk.tɪk/) sugar built on top of Promises that makes asynchronous code look and behave more like synchronous code. It greatly improves readability and maintainability (/meɪnˈteɪn/). I prefer async/await in most cases, especially in complex business logic. However, I still use Promise.all() when I need to run multiple operations in parallel ( ‘pɛrəˌlɛl  ) to improve performance. I always wrap (rap) them in try-catch for proper error handling.','[]',599,196),
('q_4','require() vs import.','Backend','require() is the CommonJS module system and loads modules synchronously. import/export is the ES Modules standard and is asynchronous. In modern Node.js projects, I use ES Modules because they support top-level await, have better performance with tree-shaking, and are the future standard of JavaScript.','[]',714,262),
('q_5','How would you design a scalable RESTful API?','Backend','I follow Clean Architecture or Layered Architecture with clear separation ( sɛpəˈreɪʃən) of concerns: Controllers for handling HTTP, Services for business logic, and Repositories for data access. I use DTOs for input validation and keep the application stateless for easy scaling. For complex projects, I also apply CQRS pattern and event-driven communication when necessary.','[]',792,370),
('q_6','What is middleware in Express?','Backend','Middleware are functions that have access to the request and response objects. They can modify them, end the request cycle, or call the next middleware. I have many custom written (/ˈrɪt̬.ən/) middlewares including JWT authentication, request logging with correlation (ˌkɔrəˈleɪʃən)  IDs, rate limiting, input sanitization (/ˌsæn.ə.təˈzeɪ.ʃən/), and centralized ( ˈsɛntrəˌlaɪzd ) error handling.','[]',820,500),
('q_7','Authentication & Authorization.','Backend','I commonly use JWT tokens combined with HttpOnly cookies for refresh tokens to prevent (/prɪˈvent/) XSS attacks. For authorization, I implement Role-Based Access Control (RBAC). In projects that need higher security, I integrate with Auth0 or Keycloak for OAuth2 and SSO.','[]',792,630),
('q_8','MongoDB vs PostgreSQL.','Database','I choose PostgreSQL when the project needs strong data consistency, complex relationships, transactions, and advanced querying (ˈkwiriɪŋ ). I choose MongoDB when the data structure is flexible or the application requires high write throughput. In many real projects, I use both (polyglot persistence) depending on the specific (spəˈsɪfɪk ) module.','[]',714,738),
('q_9','Caching strategy.','Database','I mainly use Redis as the caching layer with the cache-aside pattern. I set appropriate (əˈproʊpriət  ) TTLs for different types of data. When data is updated, I invalidate the cache using Redis Pub/Sub or by publishing events. This approach significantly improves response time and reduces database load.','[]',599,804),
('q_10','Design a real-time notification system.','System Design','I would use Socket.io with the Redis adapter to support horizontal (/ˌhɔːr.ɪˈzɑːn.t̬əl/) scaling. For very large systems, I combine it with Redis Streams or Kafka for message queuing and BullMQ for reliable background job processing. I also prepare Web Push API as a fallback for offline users.','[]',467,818),
('q_11','Horizontal scaling of Node.js app.','System Design','I run multiple Node.js instances using PM2 clusters or Docker containers. I place Nginx or a cloud load balancer in front. The application must be stateless, and I use Redis to store sessions, cache, and rate limiting data.','[]',340,777),
('q_12','How do you test a Node.js application?','DevOps & Cloud','I follow the Testing Pyramid: Unit tests with Jest for services and utilities (juˈtɪlətiz ), Integration tests with Supertest and Testcontainers for database interactions, and E2E tests with Cypress or Playwright. I aim for at least 80% coverage (ˈkʌvərəʤ ) on critical business flows.','[]',241,688),
('q_13','Monitoring production app.','DevOps & Cloud','In production, I use PM2 for process management, Prometheus + Grafana for metrics, Pino for structured logging, and Datadog or New Relic for full APM and distributed tracing.','[]',187,567),
('q_14','State management in React + Node.js.','Frontend','For large applications, I use Redux Toolkit combined with RTK Query for server state management. For simpler cases or better caching, I prefer TanStack Query (React Query) because it handles caching, background refetching, and synchronization very well.','[]',187,433),
('q_15','Conflict with teammates.','Behavioral','In one project, a teammate insisted on using a heavy library that would increase complexity. I organized a short meeting, listened to their opinion, then presented pros and cons with real data. We reached a compromise on a lighter solution. The feature was delivered successfully and team relationship remained good.','[]',241,312),
('q_16','Helping a junior developer.','Behavioral','A junior developer was struggling with asynchronous programming and debugging (diˈbʌɡɪŋ ). I scheduled pairing sessions, explained the event loop and common patterns, and created a small internal guide. After that, their confidence and output improved noticeably (/ˈnoʊ.t̬ɪ.sə.bli/).','[]',340,223),
('q_17','Teammate missing deadlines.','Behavioral','When a teammate was behind schedule, I had an honest 1:1 discussion to understand the blockers. I helped remove obstacles (/ˈɑːb.stə.kəl/ ) and updated the PM proactively (/ˌproʊˈæk.tɪv.li/). We adjusted priorities and the task was completed with good quality, though slightly (/ˈslaɪt.li/) delayed.','[]',467,182),
('q_18','Disagreed with PM on deadline.','Behavioral','The PM wanted to commit to a very tight deadline. I clearly explained the technical risks with examples and proposed two options: reduce scope or add more resources. We agreed to cut non-essential (non - /ɪˈsen.ʃəl/) features. The project was delivered on time without quality issues.','[]',599,196),
('q_19','Unrealistic deadline from PM.','Behavioral','I presented a detailed estimation breakdown and potential ( /poʊˈten.ʃəl/) risks. I suggested delivering in phases — core features first. The PM accepted the plan. The client appreciated our transparency (trænˈspɛrənsi ) and the project was successful.','[]',714,262),
('q_20','Unhappy client.','Behavioral','The client was unhappy with slow API performance. I listened carefully, reproduced the issue, optimized (ˈɑptəˌmaɪzd ) N+1 queries, and added Redis caching. I then scheduled a demo to show the big improvement. The client became very satisfied.','[]',792,370),
('q_21','Gathering requirements from clients','Behavioral','I actively joined client meetings, asked many clarifying /ˈkler.ə.faɪ.ɪŋ/ questions, and documented user stories with clear acceptance criteria /əkˈsep.təns kraɪˈtɪr.i.ə/. I also created simple prototypes /ˈproʊ.t̬ə.taɪps/ to confirm understanding before starting development. This approach greatly reduced later rework.','[]',820,500),
('q_22','Suggested better solution to client','Behavioral','The client requested a complicated custom feature. I proposed using a well-maintained open-source /ˌoʊ.pən ˈsɔːrs/ library with customization /ˌkʌs.tə.məˈzeɪ.ʃən/ instead. I showed them the time and cost comparison. They agreed with the suggestion and we saved nearly three weeks of development effort.','[]',792,630),
('q_23','Handling frequent requirement changes.','Behavioral','When requirements kept changing, I worked closely with the PM and client to understand the business impact. We reprioritized (ˌriː.praɪˈɔːr.ə.taɪzd ) the backlog together and implemented changes in small, safe increments. This helped control risk and maintain project velocity(vəˈlɑː.sə.t̬i )','[]',714,738),
('q_24','Taking initiative / Technical improvement.','Behavioral','I noticed that some APIs were slow under load. I proposed and implemented Redis caching. After getting approval, I completed the task and reduced average response time by around 65%. The team and stakeholders (/ˈsteɪkˌhoʊl.dɚz/  )were happy with the result.','[]',599,804),
('q_25','Receiving negative feedback in code review.','Behavioral','During a code review, a senior gave quite critical feedback. I stayed calm, asked for detailed explanations, fixed the issues quickly, and thanked them for the review. That experience helped me improve my coding standards significantly.','[]',467,818),
('q_26','Working with remote / timezone team.','Behavioral','I worked with teammates in Vietnam and Europe. I made sure to document all decisions, record important meetings, and adjust my schedule for better overlap time. Communication became clearer and we consistently met our sprint goals.','[]',340,777),
('q_27','Dealing with production incident.','Behavioral','Once a deployment caused service downtime. I quickly identified the root cause, rolled back the change, fixed the bug, and wrote a detailed post-mortem. We then added more automated tests to prevent similar issues in the future.','[]',241,688),
('q_28','Saying “No” to a client request.','Behavioral','The client asked for a feature that would seriously impact performance. I explained the long-term risks with data and suggested a better alternative solution. They understood and accepted my recommendation.','[]',187,567),
('q_29','How do you keep yourself updated?','Behavioral','I regularly read Node Weekly, follow official Node.js releases, try new tools in side projects, and participate in the JavaScript community.','[]',187,433),
('q_30','What is NestJS and how does it differ from Express.js? Why choose NestJS for large-scale applications?','Backend','NestJS is a progressive /prəˈɡres.ɪv/, TypeScript-based Node.js framework for building efficient and scalable /ˈskeɪ.lə.bəl/ server-side applications. It uses Express (or Fastify /ˈfæs.tɪ.faɪ/) under the hood but adds a powerful architecture inspired by Angular.
Key differences:
Built-in Dependency Injection, Modular architecture, and Decorator-based metadata.
Strong TypeScript support with OOP + Functional Programming.
Out-of-the-box support for testing, validation, authentication, microservices, etc.
We choose NestJS for large applications because it enforces clean architecture (SOLID principles), makes the codebase highly maintainable, and scales well with teams.','[]',1141,312),
('q_31','Explain the overall architecture of a NestJS application.','Backend','NestJS is based on modules. Each module contains:
Controllers → handle HTTP requests
Providers/Services → business logic (injected via DI)
Modules → organize the application into features or shared modules
The root module (AppModule) bootstraps the application. Everything is wired together through Dependency Injection.','[]',1240,223),
('q_32','What are Modules in NestJS?','Backend','Modules are the basic building blocks. There are:
Feature Modules: Encapsulate (/ɪnˈkæp.sə.leɪt/  specific business domains (e.g., UsersModule, OrdersModule)
Shared Modules: Exported to be reused (SharedModule)
Root Module: AppModule
Global Modules: Available everywhere (@Global())
Modules help with encapsulation, lazy loading, and organizing large codebases.','[]',1367,182),
('q_33','How does Dependency Injection work in NestJS?','Backend','NestJS has a powerful DI container. Providers can be injected using:
@Injectable() classes
Different provider types: useClass, useValue, useFactory, useExisting
Example:
TypeScript
@Module({
providers: [
{ provide: ''API_KEY'', useValue: ''12345'' },
{ provide: ConfigService, useFactory: (...) }
]
})','[]',1499,196),
('q_34','Controllers, Services, Providers?','Backend','Controller: Handles incoming requests, routes, and returns responses.
Service/Provider: Contains business logic and is injectable.
They interact via constructor injection.','[]',1614,262),
('q_35','Role of key decorators','Backend','@Injectable(): Marks a class as a provider that can be injected.
@Controller(): Defines a route handler class.
@Module(): Declares module metadata.
@Inject(): Explicit injection (used with custom tokens).
@Global(): Makes a module globally available.','[]',1692,370),
('q_36','What are Pipes?','Backend','Pipes transform input data or validate it.
Built-in: ValidationPipe, ParseIntPipe, etc.
Custom Pipe implements PipeTransform.
We usually use class-validator + class-transformer with ValidationPipe globally.','[]',1720,500),
('q_37','What are Guards?','Backend','Guards determine whether a request should be handled by the route handler.
Common use: Authentication /ɔːˌθen.təˈkeɪ.ʃən/ and Authorization /əˌθɔːr.ə.zəˈzeɪ.ʃən/
Example: Role-based Guard
TypeScript
@Injectable()
export class RolesGuard implements CanActivate {
canActivate(context: ExecutionContext): boolean {
const requiredRoles = this.reflector.get<string[]>(''roles'', context.getHandler());
// check user roles...
}
}','[]',1692,630),
('q_38','What are Interceptors?','Backend','Interceptors (/ˌɪn.tɚˈsep.tɚz/ )transform the result or handle side effects (logging, caching, response wrapping).
Example: Transform interceptor to wrap responses in { data, status, timestamp }.','[]',1614,738),
('q_39','Order of execution:','Backend','Middleware → Guards → (Controller) → Interceptors (before & after) → Exception Filters.','[]',1499,804),
('q_40','Dynamic Modules','Architecture','Dynamic modules allow creating modules at runtime with configuration (e.g., TypeOrmModule.forRootAsync(), ConfigModule.forRootAsync()). Very useful for configurable database or third-party modules.','[]',1367,818),
('q_41','Custom Decorators','Architecture','We can create custom method/parameter decorators using Reflector and metadata.','[]',1240,777),
('q_42','CQRS in NestJS','Architecture','NestJS supports CQRS via @nestjs/cqrs package. We separate Commands (write) and Queries (read), using Command Bus and Query Bus.','[]',1141,688),
('q_43','Microservices in NestJS','Architecture','NestJS has excellent microservice support with multiple transporters:
TCP (default)
Redis, RabbitMQ, Kafka, gRPC, MQTT, NATS
gRPC is preferred for high performance, Kafka for event-driven systems.','[]',1087,567),
('q_44','Advantages & Challenges of Microservices with NestJS','Architecture','Advantages: Scalability, independent deployment, technology heterogeneity.
Challenges: Distributed transactions, latency, tracing (use OpenTelemetry), eventual consistency.','[]',1087,433),
('q_45','Optimization for high traffic','System Design','Use Fastify adapter instead of Express
Redis caching + Cache-Aside pattern
Database indexing + query optimization
Horizontal scaling + Load balancer
Rate limiting, connection pooling
Background jobs with BullMQ','[]',1141,312),
('q_46','Caching strategies','System Design','@nestjs/cache-manager + Redis
Custom interceptor for response caching
Cache invalidation strategies (event-based)','[]',1240,223),
('q_47','Security best practices','System Design','Helmet, CORS, RateLimiter (express-rate-limit or nestjs-throttler)
ValidationPipe + class-validator
Sanitization, JWT + HttpOnly cookies','[]',1367,182),
('q_48','Unit & E2E Testing','Backend','Unit: Jest + @nestjs/testing (Test.createTestingModule)
E2E: Supertest + NestFactory
Mock dependencies using overrideModule or useValue.','[]',1499,196),
('q_49','ValidationPipe globally','Backend','TypeScript
app.useGlobalPipes(new ValidationPipe({
whitelist: true,
forbidNonWhitelisted: true,
transform: true
}));','[]',1614,262),
('q_50','JWT Authentication with Refresh Tokens','DevOps & Cloud','Use @nestjs/passport + passport-jwt.
Access Token (short-lived)
Refresh Token (long-lived, HttpOnly cookie)
Token rotation + blacklist (Redis)','[]',1692,370),
('q_51','RBAC & Policy-based Authorization','DevOps & Cloud','Combine Guards + Custom Decorators (@Roles() + RolesGuard) or CASL library for advanced policy-based access control.','[]',1720,500),
('q_52','Configuration','DevOps & Cloud','Use @nestjs/config with validation via Joi or class-validator.','[]',1692,630),
('q_53','Lifecycle Hooks','DevOps & Cloud','OnModuleInit
OnApplicationBootstrap
OnModuleDestroy, BeforeApplicationShutdown, etc.','[]',1614,738),
('q_54','Docker & Scaling','DevOps & Cloud','Multi-stage Docker build, PM2 or Node Cluster (or better: Kubernetes horizontal pod autoscaling), health checks, graceful shutdown.','[]',1499,804),
('q_55','Scenario Questions (Typical Senior Answers)','Backend','Large monolith structure: Domain-Driven Design, Clean/Hexagonal Architecture, Feature modules + Shared kernel.
Database transactions: Use TypeORM/Prisma transactions or @Transactional decorator (custom).
Performance bottlenecks: Usually N+1 queries, heavy middleware, blocking code. Use clinic.js, New Relic, or OpenTelemetry to profile.','[]',1367,818),
('q_56','What is React? What are the key features of React?','Frontend','React is a JavaScript library for building user interfaces (ˈɪn.t̬ɚ.feɪ.sɪz ), especially single-page applications. Key features:
Component-based architecture
Virtual DOM for performance
Declarative (/dɪˈkler.ə.t̬ɪv/ ) UI
One-way data binding
Strong community & ecosystem (Next.js, Redux, etc.)','[]',340,1677),
('q_57','Explain the difference between Class Components and Functional Components.','Frontend','Functional components + Hooks are now the standard. Advantages of Functional:
Cleaner code, less boilerplate (ˈbɔɪ.lɚ.pleɪt )
Better performance (no this binding issues)
Easier to test and reuse logic with custom hooks','[]',241,1588),
('q_58','What are Hooks? Explain useState, useEffect, useContext, useReducer, useMemo, useCallback.','Frontend','useState: Manage local state
useEffect: Side effects (data fetching, subscriptions)
useContext: Consume context without prop drilling
useReducer: Complex state logic (better than useState for many states)
useMemo: Memoize expensive calculations
useCallback: Memoize functions to prevent unnecessary re-renders','[]',187,1467),
('q_59','What is the Virtual DOM and how does reconciliation work?','Frontend','Virtual DOM is a lightweight copy of the real DOM. When state changes, React creates a new Virtual DOM tree, compares it with the previous one (diffing), then applies only the minimal changes to the Real DOM (reconciliation) rek.ənˌsɪl.iˈeɪ.ʃən .','[]',187,1333),
('q_60','Explain the rules of Hooks.','Frontend','Only call hooks at the top level (not inside loops, conditions, or nested functions)
Only call hooks from React functions (functional components or custom hooks)','[]',241,1212),
('q_61','What are custom hooks? Give an example.','Frontend','Custom hooks are JavaScript functions that start with use and can call other hooks.
Example:
tsx
function useLocalStorage(key: string, initialValue: any) {
const [value, setValue] = useState(() => {
return localStorage.getItem(key) || initialValue;
});
useEffect(() => {
localStorage.setItem(key, value);
}, [key, value]);
return [value, setValue];
}','[]',340,1123),
('q_62','How does React handle performance optimization?','Frontend','React.memo() for functional components
useMemo(), useCallback()
React.lazy() + Suspense for code splitting
Avoid unnecessary re-renders using proper dependency arrays
Virtualization (react-window, react-virtualized) for long lists','[]',467,1082),
('q_63','What is Context API? When should you use it instead of Redux?','Frontend','Context API is built-in state management for sharing data without prop drilling.
Use it when:
State is not too complex
You don’t need powerful devtools or middleware
For large apps with complex state → Redux / Zustand / Jotai / Recoil.','[]',599,1096),
('q_64','Compare Redux, Context API, Zustand, and Redux Toolkit.','Frontend','Redux: Predictable, great devtools, boilerplate (reduced by Redux Toolkit)
Redux Toolkit (RTK): Recommended way now (includes Immer, createSlice, RTK Query)
Zustand: Minimalist, very simple, great performance
Context + useReducer: Good for medium apps','[]',714,1162),
('q_65','What is RTK Query? How does it differ from Redux Thunk or Saga?','Frontend','RTK Query is a powerful data-fetching and caching tool built on Redux Toolkit. It handles:
Caching
Automatic refetching
Loading & error states
Polling
Optimistic updates
Much better than manual Thunk/Saga for API calls.','[]',792,1270),
('q_66','How do you structure a large React application?','Frontend','Common structures:
Feature-based / Domain-driven
Or Atomic Design (Atoms, Molecules, Organisms, Templates, Pages)
Example:text
src/
├── features/
├── components/
├── hooks/
├── store/
├── utils/
├── api/
└── pages/','[]',820,1400),
('q_67','Explain Server-Side Rendering (SSR) vs Client-Side Rendering (CSR). When to use Next.js?','Frontend','CSR: Faster initial load, but bad SEO and slow first contentful paint
SSR: Better SEO, faster first paint, but more server load
Next.js is the best choice for SSR/SSG/ISR in React ecosystem.','[]',792,1530),
('q_68','What are common performance issues in React and how do you debug them?','Frontend','Too many re-renders → React DevTools Profiler
Large bundle size → Code splitting + lazy loading
Heavy computations → useMemo
Long lists → Virtualization','[]',714,1638),
('q_69','How do you handle authentication in React? (with NestJS backend)','Frontend','Use Context or Redux for auth state
Store JWT in HttpOnly cookie (recommended) or memory (with refresh token rotation)
Axios instance with interceptors for token refresh
Protected routes using Higher-Order Components or custom hooks','[]',599,1704),
('q_70','How would you implement a highly scalable dashboard with real-time updates?','Frontend','State: Zustand or Redux
Real-time: WebSocket + Socket.io or Server-Sent Events
Data fetching: RTK Query or TanStack Query
UI: React Table + TanStack Virtual for large datasets
Performance: Memoization + Code splitting','[]',467,1718),
('q_71','Explain Error Boundaries and how you handle global error handling.','Frontend','Error Boundaries catch JavaScript errors in child components.
Global handling: Combine Error Boundary + Error reporting (Sentry).','[]',340,1677),
('q_72','What are Render Props and Higher-Order Components (HOC)? When to use each?','Frontend','Both are patterns for code reuse.
Render Props: More flexible, better with hooks era
HOC: Still useful for cross-cutting concerns (auth, logging)','[]',241,1588),
('q_73','How do you optimize bundle size in a large React app?','Frontend','Code splitting (React.lazy + Suspense)
Tree shaking
Dynamic imports
Analyze with webpack-bundle-analyzer
Use Vite instead of CRA for faster builds','[]',187,1467),
('q_74','Self Introduction & Experience (Korea project)','Behavioral','I have 8 years of backend experience / with PHP and Node.js.
I also have 3 years of frontend experience / with Vue.js / and many other technologies.
My latest Node.js project / was a mobile phone sales application / for customers in South Korea.
I worked as a Senior ( ˈsiːniə) Developer / responsible for the API / and AWS infrastructure. ( ˌɪnfrəˈstrʌkʧər )
The API was built with Express.js / and PostgreSQL database.
The project ( ˈprɒʤɛkt ) used a monolithic ( ˌmɑnəˈlɪθɪk )architecture / not microservices.
I designed it using Module structure.
When an API is called / the request goes through middleware and guards / then enters the module / then to the controller.
Inside the controller / there are actions.
Inside those actions / we have jobs / which can be async or queue jobs / depending on the purpose.
After processing / it returns the response.
For database / I used Sequelize ORM.
The most difficult issue I faced was the notification feature ( ˈfiːʧə ) for campaigns.
The requirement said about 200 notifications per campaign.
But in production / the server suddenly crashed.
After checking the logs / I found up to 10,000 notifications were sent at once / which killed the server.
I immediately made a detailed incident report / explaining the root cause.
I also proposed a solution:
Separate the queue server / from the main API server / to avoid affecting it.
And implement ( ˈɪmpləmənt )chunking / send notifications in small batches / about 10 to 20 batches / gradually ( ˈɡræʤuəli )into the queue.
Because the client was not technical / I made the report and proposal very clear and detailed.
My solution was approved / and successfully implemented ( ( ˈɪmpləməntid )/ which completely solved the problem.','[]',1087,1333),
('q_75','Project: Emission Management (Japan)','Behavioral','My most recent project / was an Emission Management System / for Japanese clients.
The system includes various functions such as:
Registering ( ˈrɛʤɪstərɪŋ ) emission amounts / across different industries.
Each industry / has its own unique calculation formula.
There are also features for / reviewing and approving emissions / and predicting future emission amounts / for the coming years / and so on.
This project had many difficult issues / but most of them / were related to handling large volumes of data.
The hardest issue for me / happened after 3 years of development.
The project started facing serious performance problems / with data rendering on the web client side.
Previously / the data tables / would fetch all the data from the API / and display it on the UI.
The frontend data table library / would handle filtering / pagination / and search / entirely (ɪnˈtaɪərli )on the client side.
Over time / as the data grew ( gru: )much larger / whenever users opened big data tables / the page would freeze / or even crash.
Data tables like this / existed everywhere in the project.
To solve this problem / we had to move all the logic for / pagination / filtering / and search / from the frontend / to the backend API.
This made the client-side rendering / much lighter and smoother.
This change required us / to refactor a very large amount of code / and perform extensive testing.
At the same time / we still had to deliver new features on schedule.
Because of this / we had to work a lot of overtime.
It took us 3 months / to fully complete the migration / and release it successfully.
This major issue / made me think deeply / about /the importance of good architecture design /from the beginning.
During the process / I also learned many new /and valuable optimization techniques.','[]',1141,1212),
('q_76','How do you handle production issues or bugs that appear suddenly?','Behavioral','When a production issue occurs / I follow these steps:
First / I stay calm and quickly check the logs and monitoring tools to understand the impact.
Second / I try to reproduce the issue if possible / and identify the root cause.
Third / I create a short incident report / explain the problem clearly / and propose immediate fixes and long-term solutions.
I believe quick response / clear communication / and ownership are the keys to handling production issues well.','[]',1240,1123),
('q_77','Why are you leaving your current job? / Why did you leave your last job?','Behavioral','I really enjoyed working at my last company ( ˈkʌmpəni ) / and learned a lot.
However / I feel I have reached a point where I want new challenges / especially in larger systems or more complex architecture.
I’m looking for a role where I can contribute more as a Senior Developer / work with modern technologies / and have more opportunities to design scalable ( ˈskeɪləbᵊl )solutions','[]',1367,1082),
('q_78','What are your strengths and weaknesses?','Behavioral','My biggest strength / is problem-solving under pressure.
When production issues happen / I can stay calm / quickly investigate ( ɪnˈvɛstəˌɡeɪt )/ and provide clear reports with solutions.
I also have strong ownership — I always take responsibility for the features I work on.
For weaknesses / I used to spend too much time trying to make the code perfect.
But I’ve improved by focusing more on business value / and learning to balance quality with deadlines.
Now I prioritize tasks better.','[]',1499,1096),
('q_79','Tell me about a time you had a conflict with a teammate. How did you handle it?','Behavioral','One time / in the Emission Management project / I had a conflict with a frontend developer.
He wanted to keep all the filtering and pagination logic on the client side / because it was faster to implement. ( ˈɪmpləmənt )
But I saw that with the growing data / it would cause serious performance issues later.
We had different opinions during a technical discussion.
Instead of arguing ( ˈɑrɡjuɪŋ ) / I prepared a small demo / showing how the page would freeze with real data volume.
I also listened to his concerns about development time.
Then we discussed together with the team lead / and finally agreed on a compromise solution.
We moved the heavy logic to the backend / which solved the performance problem.','[]',1614,1162),
('q_80','What is your orientation?','Behavioral','My career orientation ( ˌɔriɛnˈteɪʃən )/ is to become a strong Senior Backend Engineer / and eventually a Technical Lead or Software Architect.
I want to focus on building scalable ( ˈskeɪləbᵊl ), high-performance systems / especially systems that handle large volumes of data.
I enjoy solving complex technical problems / improving system architecture / and mentoring junior developers.
In the next 3 to 5 years / I want to deepen my expertise in cloud infrastructure  ( ˌɪnfrəˈstrʌkʧər )(AWS) / and system design.
I also want to work on more challenging projects / where I can take more ownership ( ˈoʊnərˌʃɪp )/ and deliver real business impact','[]',1692,1270);

INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_nodejs_part-of','root','t_nodejs','part-of'),
('e_root_t_nestjs_part-of','root','t_nestjs','part-of'),
('e_root_t_react_part-of','root','t_react','part-of'),
('e_root_t_about_part-of','root','t_about','part-of'),
('e_t_nodejs_s_1_part-of','t_nodejs','s_1','part-of'),
('e_t_nodejs_s_2_part-of','t_nodejs','s_2','part-of'),
('e_t_nodejs_s_3_part-of','t_nodejs','s_3','part-of'),
('e_t_nodejs_s_4_part-of','t_nodejs','s_4','part-of'),
('e_t_nodejs_s_5_part-of','t_nodejs','s_5','part-of'),
('e_t_nodejs_s_6_part-of','t_nodejs','s_6','part-of'),
('e_t_nodejs_s_7_part-of','t_nodejs','s_7','part-of'),
('e_t_nestjs_s_8_part-of','t_nestjs','s_8','part-of'),
('e_t_nestjs_s_9_part-of','t_nestjs','s_9','part-of'),
('e_t_nestjs_s_10_part-of','t_nestjs','s_10','part-of'),
('e_t_nestjs_s_11_part-of','t_nestjs','s_11','part-of'),
('e_t_nestjs_s_12_part-of','t_nestjs','s_12','part-of'),
('e_t_nestjs_s_13_part-of','t_nestjs','s_13','part-of'),
('e_t_nestjs_s_14_part-of','t_nestjs','s_14','part-of'),
('e_t_nestjs_s_15_part-of','t_nestjs','s_15','part-of'),
('e_t_react_s_16_part-of','t_react','s_16','part-of'),
('e_t_react_s_17_part-of','t_react','s_17','part-of'),
('e_t_react_s_18_part-of','t_react','s_18','part-of'),
('e_t_react_s_19_part-of','t_react','s_19','part-of'),
('e_t_react_s_20_part-of','t_react','s_20','part-of'),
('e_s_1_q_1_part-of','s_1','q_1','part-of'),
('e_s_1_q_2_part-of','s_1','q_2','part-of'),
('e_s_1_q_3_part-of','s_1','q_3','part-of'),
('e_s_1_q_4_part-of','s_1','q_4','part-of'),
('e_s_2_q_5_part-of','s_2','q_5','part-of'),
('e_s_2_q_6_part-of','s_2','q_6','part-of'),
('e_s_2_q_7_part-of','s_2','q_7','part-of'),
('e_s_3_q_8_part-of','s_3','q_8','part-of'),
('e_s_3_q_9_part-of','s_3','q_9','part-of'),
('e_s_4_q_10_part-of','s_4','q_10','part-of'),
('e_s_4_q_11_part-of','s_4','q_11','part-of'),
('e_s_5_q_12_part-of','s_5','q_12','part-of'),
('e_s_5_q_13_part-of','s_5','q_13','part-of'),
('e_s_6_q_14_part-of','s_6','q_14','part-of'),
('e_s_7_q_15_part-of','s_7','q_15','part-of'),
('e_s_7_q_16_part-of','s_7','q_16','part-of'),
('e_s_7_q_17_part-of','s_7','q_17','part-of'),
('e_s_7_q_18_part-of','s_7','q_18','part-of'),
('e_s_7_q_19_part-of','s_7','q_19','part-of'),
('e_s_7_q_20_part-of','s_7','q_20','part-of'),
('e_s_7_q_21_part-of','s_7','q_21','part-of'),
('e_s_7_q_22_part-of','s_7','q_22','part-of'),
('e_s_7_q_23_part-of','s_7','q_23','part-of'),
('e_s_7_q_24_part-of','s_7','q_24','part-of'),
('e_s_7_q_25_part-of','s_7','q_25','part-of'),
('e_s_7_q_26_part-of','s_7','q_26','part-of'),
('e_s_7_q_27_part-of','s_7','q_27','part-of'),
('e_s_7_q_28_part-of','s_7','q_28','part-of'),
('e_s_7_q_29_part-of','s_7','q_29','part-of'),
('e_s_8_q_30_part-of','s_8','q_30','part-of'),
('e_s_8_q_31_part-of','s_8','q_31','part-of'),
('e_s_8_q_32_part-of','s_8','q_32','part-of'),
('e_s_8_q_33_part-of','s_8','q_33','part-of'),
('e_s_8_q_34_part-of','s_8','q_34','part-of'),
('e_s_9_q_35_part-of','s_9','q_35','part-of'),
('e_s_9_q_36_part-of','s_9','q_36','part-of'),
('e_s_9_q_37_part-of','s_9','q_37','part-of'),
('e_s_9_q_38_part-of','s_9','q_38','part-of'),
('e_s_9_q_39_part-of','s_9','q_39','part-of'),
('e_s_10_q_40_part-of','s_10','q_40','part-of'),
('e_s_10_q_41_part-of','s_10','q_41','part-of'),
('e_s_10_q_42_part-of','s_10','q_42','part-of'),
('e_s_10_q_43_part-of','s_10','q_43','part-of'),
('e_s_10_q_44_part-of','s_10','q_44','part-of'),
('e_s_11_q_45_part-of','s_11','q_45','part-of'),
('e_s_11_q_46_part-of','s_11','q_46','part-of'),
('e_s_11_q_47_part-of','s_11','q_47','part-of'),
('e_s_12_q_48_part-of','s_12','q_48','part-of'),
('e_s_12_q_49_part-of','s_12','q_49','part-of'),
('e_s_13_q_50_part-of','s_13','q_50','part-of'),
('e_s_13_q_51_part-of','s_13','q_51','part-of'),
('e_s_14_q_52_part-of','s_14','q_52','part-of'),
('e_s_14_q_53_part-of','s_14','q_53','part-of'),
('e_s_14_q_54_part-of','s_14','q_54','part-of'),
('e_s_15_q_55_part-of','s_15','q_55','part-of'),
('e_s_16_q_56_part-of','s_16','q_56','part-of'),
('e_s_16_q_57_part-of','s_16','q_57','part-of'),
('e_s_16_q_58_part-of','s_16','q_58','part-of'),
('e_s_16_q_59_part-of','s_16','q_59','part-of'),
('e_s_17_q_60_part-of','s_17','q_60','part-of'),
('e_s_17_q_61_part-of','s_17','q_61','part-of'),
('e_s_17_q_62_part-of','s_17','q_62','part-of'),
('e_s_17_q_63_part-of','s_17','q_63','part-of'),
('e_s_18_q_64_part-of','s_18','q_64','part-of'),
('e_s_18_q_65_part-of','s_18','q_65','part-of'),
('e_s_19_q_66_part-of','s_19','q_66','part-of'),
('e_s_19_q_67_part-of','s_19','q_67','part-of'),
('e_s_19_q_68_part-of','s_19','q_68','part-of'),
('e_s_19_q_69_part-of','s_19','q_69','part-of'),
('e_s_20_q_70_part-of','s_20','q_70','part-of'),
('e_s_20_q_71_part-of','s_20','q_71','part-of'),
('e_s_20_q_72_part-of','s_20','q_72','part-of'),
('e_s_20_q_73_part-of','s_20','q_73','part-of'),
('e_t_about_q_74_part-of','t_about','q_74','part-of'),
('e_t_about_q_75_part-of','t_about','q_75','part-of'),
('e_t_about_q_76_part-of','t_about','q_76','part-of'),
('e_t_about_q_77_part-of','t_about','q_77','part-of'),
('e_t_about_q_78_part-of','t_about','q_78','part-of'),
('e_t_about_q_79_part-of','t_about','q_79','part-of'),
('e_t_about_q_80_part-of','t_about','q_80','part-of');
