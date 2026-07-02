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


-- ===================================================================
--  BỔ SUNG: Node.js Core (chi tiết) — xem thêm seed_nodejs_core.sql
-- ===================================================================
-- ------------------------- NODES -----------------------------------
INSERT INTO kg_nodes (id,label,category,description,links,pos_x,pos_y) VALUES
-- Topic
('t_ndc','Node.js Core (Chi tiết)','Backend','Kiến thức chuyên sâu về nhân Node.js: Event Loop/libuv, module system, streams, EventEmitter, đa tiến trình & đa luồng, core modules, xử lý lỗi và V8/bộ nhớ. Mục tiêu là hiểu bản chất runtime để trả lời sâu khi phỏng vấn Senior.','[]',950,150),

-- Sections
('s_ndc_1','Event Loop & Bất đồng bộ','Backend','Cách Node xử lý I/O không chặn: kiến trúc runtime, các phase của event loop, micro/macrotask và cách tránh chặn luồng.','[]',600,300),
('s_ndc_2','Module System (CommonJS & ESM)','Backend','Hai hệ module của Node: cách nạp, cache, phân giải đường dẫn, và tương tác giữa CommonJS và ES Modules.','[]',1300,300),
('s_ndc_3','Streams & Buffer','Backend','Xử lý dữ liệu theo luồng để tiết kiệm bộ nhớ: các loại stream, backpressure, chế độ hoạt động và dữ liệu nhị phân Buffer.','[]',450,500),
('s_ndc_4','EventEmitter & Sự kiện','Backend','Mô hình phát/nghe sự kiện — nền tảng của nhiều API core (stream, http, process).','[]',1450,500),
('s_ndc_5','Process, Child Process & Cluster','Backend','Đối tượng process, tạo tiến trình con và nhân bản tiến trình để tận dụng nhiều CPU core.','[]',400,750),
('s_ndc_6','Worker Threads & Đa luồng','System Design','Chạy JS song song trong cùng tiến trình cho tác vụ CPU-bound; chia sẻ bộ nhớ an toàn.','[]',1500,750),
('s_ndc_7','Core Modules (fs, http, crypto...)','Backend','Các module lõi thường dùng và cách chúng tương tác với event loop/thread pool.','[]',600,950),
('s_ndc_8','Error Handling & Async Context','Backend','Phân loại lỗi, bắt lỗi trong async, xử lý lỗi toàn cục và truyền context xuyên chuỗi bất đồng bộ.','[]',1300,950),
('s_ndc_9','V8, Bộ nhớ & Hiệu năng','DevOps & Cloud','Engine V8, garbage collection, rò rỉ bộ nhớ và cách đo/tối ưu hiệu năng.','[]',950,1050),

-- ===== Section 1: Event Loop =====
('n_el_arch','Kiến trúc runtime: V8 + libuv','Backend',
'Node.js = V8 (máy ảo chạy JS, cùng engine với Chrome)
       + libuv (event loop + thread pool + I/O bất đồng bộ)
       + các C++ binding + thư viện core viết bằng JS.

Ở tầng JavaScript, code CỦA BẠN chạy trên MỘT luồng duy
nhất (main thread). Nhưng bên dưới, libuv có một thread
pool (mặc định 4 luồng) để làm việc blocking như đọc file,
DNS, crypto nặng.

Mô hình tổng quát:
  single-threaded event loop + non-blocking I/O

Ví dụ phân biệt luồng:
  const os = require("os");
  console.log(os.cpus().length);  // vd 8 core máy
  // nhưng code JS vẫn chỉ chạy trên 1 luồng; muốn dùng
  // hết core phải cluster / worker_threads

Vì thế Node rất hợp I/O-bound (API, mạng, DB) và cần kỹ
thuật riêng cho CPU-bound.','[]',500,180),

('n_el_phases','6 phase của Event Loop','Backend',
'Event loop lặp vô hạn qua các phase cố định, mỗi phase có
hàng đợi callback riêng:
  1. timers        - setTimeout / setInterval đến hạn
  2. pending cbs   - vài callback I/O hoãn từ vòng trước
  3. idle/prepare  - nội bộ
  4. poll          - nhận & chạy callback I/O (đọc socket)
  5. check         - setImmediate
  6. close cbs     - vd socket.on("close")

Giữa mỗi phase, Node xả hết microtask (nextTick rồi
Promise) mới đi tiếp.

Ví dụ thứ tự phase:
  const fs = require("fs");
  fs.readFile(__filename, () => {   // callback chạy ở poll
    setImmediate(() => console.log("check"));
    setTimeout(() => console.log("timers"), 0);
  });
  // In: check -> timers
  // vì sau poll là check, còn timers phải chờ vòng sau

Xem sâu ở node "Event loop chạy chi tiết một tick".','[]',620,180),

('n_el_micro_macro','Microtask vs Macrotask','Backend',
'Macrotask = callback trong các phase (timers, I/O,
setImmediate, close). Microtask = 2 hàng đợi ưu tiên cao,
chạy XEN GIỮA các macrotask:
  • process.nextTick queue        (ưu tiên 1)
  • Promise / queueMicrotask queue (ưu tiên 2)

Luật: sau mỗi macrotask, xả HẾT nextTick rồi HẾT Promise,
mới tới macrotask kế. Nên microtask luôn chạy trước
setTimeout dù timeout = 0.

Ví dụ:
  setTimeout(() => console.log("macro"), 0);
  Promise.resolve().then(() => console.log("micro"));
  process.nextTick(() => console.log("nextTick"));
  // In: nextTick -> micro -> macro

Bẫy: microtask sinh microtask được xả hết trong cùng lượt
-> chuỗi microtask quá dài có thể trì hoãn I/O.','[]',740,180),

('n_el_nexttick','process.nextTick vs setImmediate','Backend',
'Hai cách hoãn việc, khác nhau về thời điểm chạy:
  • process.nextTick(cb): chạy NGAY sau thao tác hiện tại,
    TRƯỚC khi event loop đi tiếp (microtask, ưu tiên còn
    cao hơn Promise).
  • setImmediate(cb): chạy ở phase check, tức LƯỢT sau,
    sau khi loop đã ghé qua poll (I/O).

Ví dụ:
  setImmediate(() => console.log("immediate"));
  process.nextTick(() => console.log("nextTick"));
  // In: nextTick -> immediate

Quy tắc dùng:
  • Cần chạy trước mọi thứ (vd phát lỗi đồng nhất) -> nextTick
  • Cần nhường I/O, lặp an toàn                    -> setImmediate

Lạm dụng nextTick đệ quy -> đói I/O (xem node starvation).','[]',500,240),

('n_el_timers','Timers & độ chính xác','Backend',
'setTimeout/setInterval KHÔNG chính xác tuyệt đối: chạy ở
phase timers và đảm bảo >= thời gian đặt, không đúng từng
ms (phụ thuộc tải event loop). setTimeout(fn,0) tối thiểu
thực chất ~1ms.

Ví dụ trễ hơn mong đợi:
  const t = Date.now();
  setTimeout(() => {
    console.log(Date.now() - t);  // có thể 5, 20... ms
  }, 0);
  for (let i = 0; i < 1e9; i++) {} // chặn loop -> timer trễ

Nhớ clearTimeout/clearInterval để tránh rò rỉ và tránh giữ
tiến trình sống ngoài ý muốn.

Timer dạng Promise:
  import { setTimeout as sleep } from "timers/promises";
  await sleep(1000);','[]',620,240),

('n_el_blocking','Chặn Event Loop & cách tránh','Backend',
'Việc CPU nặng chạy trên luồng JS sẽ CHẶN mọi request khác
(chỉ có 1 luồng). Thủ phạm: vòng lặp lớn, JSON.parse chuỗi
khổng lồ, crypto đồng bộ, regex catastrophic backtracking,
đọc cả file lớn vào RAM.

Ví dụ CHẶN (xấu):
  app.get("/hash", (req, res) => {
    const h = crypto.pbkdf2Sync(pw, salt, 1e6, 64, "sha512");
    res.send(h);   // mọi request khác đứng chờ tại đây
  });

Cách tránh:
  • Dùng bản async (pbkdf2 thay vì pbkdf2Sync) -> thread pool
  • Đẩy tính toán sang Worker Threads
  • Chia nhỏ tác vụ bằng setImmediate
  • Dùng stream thay vì đọc hết file

Đo độ trễ loop: perf_hooks.monitorEventLoopDelay().','[]',740,240),

-- ===== Section 2: Modules =====
('n_mod_cjs','CommonJS: require & module.exports','Backend',
'CommonJS (CJS) nạp module ĐỒNG BỘ; require() trả về
module.exports. Lưu ý: exports chỉ là alias trỏ tới
module.exports — gán lại nguyên exports sẽ mất tác dụng.

Ví dụ:
  // math.js
  function add(a, b) { return a + b; }
  module.exports = { add };     // ĐÚNG
  // exports = { add };         // SAI: mất liên kết

  // app.js
  const { add } = require("./math");
  console.log(add(2, 3));       // 5

Circular dependency: require trả về phần exports CHƯA hoàn
chỉnh tại thời điểm gọi -> có thể nhận undefined nếu dùng
quá sớm.','[]',1200,180),

('n_mod_wrapper','Module wrapper & biến module','Backend',
'Mỗi file CJS được Node BỌC trong một hàm trước khi chạy:
  (function (exports, require, module, __filename, __dirname) {
     // code của bạn ở đây
  });

Nhờ vậy: biến khai báo trong file là CỤC BỘ (không rơi vào
global) và luôn có sẵn 5 tham số trên.

Ví dụ:
  console.log(__dirname);   // thư mục chứa file
  console.log(__filename);  // đường dẫn đầy đủ của file
  // ở cấp module CJS: this === module.exports

Đây là lý do không cần tự viết IIFE để tránh rò biến ra
global như khi dùng thẻ <script> trên trình duyệt.','[]',1320,180),

('n_mod_resolution','Thuật toán phân giải module','Backend',
'require("x") tìm theo thứ tự:
  1. Core module? ("fs","path"...) -> dùng luôn
  2. Bắt đầu "./" hay "../" -> file/thư mục tương đối
  3. Còn lại -> tìm trong node_modules, đi NGƯỢC lên các
     thư mục cha cho tới gốc
  4. Trong package: đọc package.json (main / exports);
     nếu là thư mục thì thử index.js
  Đuôi thử lần lượt: .js -> .json -> .node

Ví dụ node_modules lookup — /app/src/a.js gọi require("lodash"):
  tìm /app/src/node_modules/lodash
      /app/node_modules/lodash     <- thấy ở đây
      /node_modules/lodash

Module đã nạp được cache trong require.cache theo đường dẫn
tuyệt đối -> require lần 2 KHÔNG chạy lại file.','[]',1440,180),

('n_mod_esm','ES Modules trong Node','Backend',
'ES Modules (ESM) kích hoạt bằng đuôi .mjs hoặc
"type":"module" trong package.json. import/export TĨNH, nạp
BẤT ĐỒNG BỘ, hỗ trợ top-level await.

Ví dụ:
  // math.mjs
  export function add(a, b) { return a + b; }
  export default 42;

  // app.mjs
  import answer, { add } from "./math.mjs";
  const res = await fetch(url);   // top-level await OK

Khác CJS:
  • Không có __dirname/__filename; thay bằng:
      import { fileURLToPath } from "url";
      const __filename = fileURLToPath(import.meta.url);
  • import là live binding (thấy giá trị export cập nhật)
  • Phân tích tĩnh -> hỗ trợ tree-shaking
  • Luôn ở strict mode','[]',1200,240),

('n_mod_interop','Interop CommonJS ↔ ESM','Backend',
'ESM và CJS làm việc với nhau nhưng KHÔNG đối xứng:
  • ESM import CJS: ĐƯỢC. default = module.exports.
      import pkg from "cjs-lib";
      const { foo } = pkg;   // named đôi khi không tách được
  • CJS require ESM: KHÔNG trực tiếp (ESM bất đồng bộ).
    Phải dùng import động:
      const esm = await import("./mod.mjs");

import() động trả Promise, dùng được ở cả CJS lẫn ESM và
cho phép nạp lười (lazy):
  if (cond) {
    const { heavy } = await import("./heavy.js");
  }

Lưu ý: trong ESM không có require/module/exports mặc định.','[]',1440,240),

-- ===== Section 3: Streams & Buffer =====
('n_stream_types','4 loại Stream','Backend',
'Stream xử lý dữ liệu theo từng CHUNK -> không cần nạp cả
file vào RAM. 4 loại:
  • Readable  - nguồn đọc: fs.createReadStream, req
  • Writable  - đích ghi: res, fs.createWriteStream
  • Duplex    - hai chiều: TCP socket
  • Transform - Duplex biến đổi dữ liệu: zlib.gzip, crypto

Ví dụ copy file mà không ngốn RAM dù file 10GB:
  const fs = require("fs");
  fs.createReadStream("big.mp4")
    .pipe(fs.createWriteStream("copy.mp4"));

So với đọc hết một lần (ngốn RAM, có thể sập tiến trình):
  const data = fs.readFileSync("big.mp4"); // nạp cả 10GB

Stream là nền của HTTP, file, nén, mã hoá trong Node.','[]',350,440),

('n_stream_backpressure','Backpressure & pipeline','Backend',
'Backpressure = cơ chế ghìm khi bên GHI chậm hơn bên ĐỌC,
để dữ liệu không dồn vô hạn trong bộ nhớ.

Cơ chế: write() trả false khi buffer nội bộ (highWaterMark)
đầy -> nên dừng đọc, chờ sự kiện "drain" mới ghi tiếp.
pipe() và pipeline() TỰ xử lý việc này.

Ví dụ nên dùng pipeline (tự xử lý lỗi + đóng tài nguyên):
  const { pipeline } = require("stream/promises");
  const fs = require("fs");
  const zlib = require("zlib");
  await pipeline(
    fs.createReadStream("in.txt"),
    zlib.createGzip(),
    fs.createWriteStream("in.txt.gz")
  );

Tránh nối pipe() thủ công nhiều tầng vì dễ rò tài nguyên
khi có lỗi giữa chừng.','[]',470,440),

('n_stream_modes','Flowing vs Paused mode','Backend',
'Readable có 2 chế độ đọc:
  • paused  - chủ động gọi .read()
  • flowing - dữ liệu tự chảy qua sự kiện "data"
Gắn listener "data" hoặc gọi .pipe()/.resume() -> chuyển
sang flowing; .pause() -> quay lại paused.

Ví dụ flowing:
  rs.on("data", chunk => console.log(chunk.length));
  rs.on("end",  () => console.log("xong"));

objectMode - cho phép stream truyền object thay vì chỉ
Buffer/string:
  const { Readable } = require("stream");
  Readable.from([{ a: 1 }, { a: 2 }])
    .on("data", o => console.log(o.a));   // 1, 2','[]',350,560),

('n_buffer','Buffer & dữ liệu nhị phân','Backend',
'Buffer là vùng nhớ nhị phân cố định NẰM NGOÀI heap V8, đại
diện một dãy byte. Là lớp con của Uint8Array.

Tạo Buffer:
  Buffer.alloc(8);            // 8 byte, zero-filled (an toàn)
  Buffer.allocUnsafe(8);      // nhanh hơn, có thể chứa rác
  Buffer.from("hi", "utf8");  // từ chuỗi

Chuyển đổi encoding:
  const b = Buffer.from("Xin chào");
  b.toString("utf8");    // "Xin chào"
  b.toString("hex");     // vd "58696e..."
  b.toString("base64");

Dùng cho file, network, crypto — nơi làm việc với byte thô
thay vì text.','[]',470,560),

-- ===== Section 4: EventEmitter =====
('n_ee_basic','EventEmitter cơ bản','Backend',
'EventEmitter là nền của mô hình sự kiện trong Node; nhiều
đối tượng core kế thừa nó (stream, http.Server, process).

Ví dụ:
  const { EventEmitter } = require("events");
  const bus = new EventEmitter();
  bus.on("order", (id) => console.log("Xử lý đơn", id));
  bus.once("boot", () => console.log("chạy 1 lần"));
  bus.emit("order", 101);  // emit ĐỒNG BỘ -> gọi listener ngay

API chính: on/addListener, once, emit, off/removeListener.

Sự kiện "error" đặc biệt: nếu emit "error" mà KHÔNG có
listener nào -> Node throw và crash:
  bus.on("error", err => console.error(err)); // nên luôn có','[]',1350,440),

('n_ee_leak','Memory leak & maxListeners','Backend',
'emit là ĐỒNG BỘ, gọi các listener tuần tự -> listener nặng
sẽ chặn luồng.

Node cảnh báo khi một sự kiện có > 10 listener
(MaxListenersExceededWarning) — thường do quên gỡ listener:
  emitter.setMaxListeners(20);        // nâng ngưỡng nếu cần
  emitter.removeListener("data", fn); // nhớ gỡ khi xong

Dùng với async:
  const { once, on } = require("events");
  await once(emitter, "ready");       // chờ sự kiện bằng Promise
  for await (const [msg] of on(emitter, "data")) { /* ... */ }

Rò rỉ listener là nguyên nhân memory leak phổ biến trong
app chạy lâu (xem node Memory leak).','[]',1550,440),

-- ===== Section 5: Process / Cluster =====
('n_process_obj','Đối tượng process','Backend',
'process là global đại diện tiến trình Node hiện tại.
Thuộc tính/hàm hay dùng:
  process.argv            // tham số dòng lệnh
  process.env             // biến môi trường
  process.pid             // id tiến trình
  process.cwd()           // thư mục làm việc
  process.memoryUsage()   // { rss, heapUsed, ... }
  process.hrtime.bigint() // đo thời gian nano giây

Ví dụ đọc arg + env — chạy: node app.js --port 4000
  const port = process.env.PORT || 3000;
  console.log(process.argv.slice(2)); // ["--port","4000"]

Sự kiện vòng đời:
  process.on("exit", code => console.log("thoát", code));','[]',300,690),

('n_child_process','child_process: spawn/exec/fork','Backend',
'Tạo tiến trình con để chạy lệnh hệ thống hoặc tách việc
nặng. 4 API chính:
  • spawn    - stream I/O, tốt cho output lớn
  • exec     - chạy qua shell, buffer toàn bộ output
  • execFile - như exec nhưng KHÔNG qua shell (an toàn hơn)
  • fork     - tạo tiến trình Node con + kênh IPC

Ví dụ spawn:
  const { spawn } = require("child_process");
  const ls = spawn("ls", ["-la"]);
  ls.stdout.on("data", d => console.log(String(d)));

Ví dụ fork (giao tiếp 2 chiều qua message):
  const child = fork("worker.js");
  child.send({ job: 1 });
  child.on("message", m => console.log("kết quả", m));

Ưu tiên execFile/spawn (không shell) để tránh shell
injection khi có input người dùng.','[]',420,690),

('n_cluster','Cluster module','Backend',
'cluster nhân bản tiến trình Node (worker) để tận dụng
NHIỀU CPU core; master phân phối kết nối trên CÙNG một cổng.

Ví dụ:
  const cluster = require("cluster");
  const os = require("os");
  if (cluster.isPrimary) {
    for (let i = 0; i < os.cpus().length; i++) cluster.fork();
  } else {
    require("./server.js");   // mỗi worker chạy server
  }

Lưu ý:
  • Mỗi worker là 1 PROCESS riêng, bộ nhớ TÁCH BIỆT -> state
    dùng chung (session, cache) phải để ngoài (Redis).
  • Thực tế thường dùng PM2: pm2 start app.js -i max
    (lớp bọc tiện dụng quanh cluster).

So với worker_threads: cluster hợp scale I/O/HTTP.','[]',300,810),

('n_signals','Signals & Graceful shutdown','Backend',
'Graceful shutdown = tắt server êm khi nhận tín hiệu dừng
(SIGTERM khi Docker/K8s rolling update, SIGINT khi Ctrl+C)
để không cắt ngang request đang chạy.

Ví dụ:
  const server = app.listen(3000);
  function shutdown() {
    server.close(() => {   // ngừng nhận kết nối mới
      db.end();            // đóng DB
      process.exit(0);
    });
    setTimeout(() => process.exit(1), 10000); // ép thoát nếu treo
  }
  process.on("SIGTERM", shutdown);
  process.on("SIGINT", shutdown);

Thiếu bước này -> deploy sẽ ngắt đột ngột các request đang
xử lý, gây lỗi cho người dùng.','[]',420,810),

-- ===== Section 6: Worker Threads =====
('n_worker_threads','worker_threads','System Design',
'worker_threads chạy JS SONG SONG trên nhiều luồng trong
CÙNG tiến trình -> dành cho việc CPU-bound (mã hoá, xử lý
ảnh, tính toán) mà không chặn luồng chính.

Ví dụ:
  // main.js
  const { Worker } = require("worker_threads");
  const w = new Worker("./calc.js", { workerData: 40 });
  w.on("message", r => console.log("fib =", r));

  // calc.js
  const { parentPort, workerData } = require("worker_threads");
  function fib(n) { return n < 2 ? n : fib(n-1) + fib(n-2); }
  parentPort.postMessage(fib(workerData));

Mỗi worker có V8 + event loop riêng. Giao tiếp qua
postMessage (structured clone) hoặc SharedArrayBuffer.
Khác cluster: worker chia sẻ được bộ nhớ, nhẹ hơn process.','[]',1400,690),

('n_shared_mem','SharedArrayBuffer & Atomics','System Design',
'Mặc định dữ liệu gửi giữa các worker bị COPY (structured
clone). SharedArrayBuffer cho phép nhiều worker cùng đọc/
ghi MỘT vùng nhớ mà không copy -> hiệu năng cao.

Atomics đảm bảo thao tác nguyên tử + đồng bộ, tránh race
condition:
  const sab = new SharedArrayBuffer(4);
  const arr = new Int32Array(sab);
  Atomics.add(arr, 0, 5);   // cộng nguyên tử
  Atomics.load(arr, 0);     // đọc an toàn
  // Atomics.wait / notify: đồng bộ giữa các luồng

Truyền sab cho worker qua workerData/postMessage; mọi luồng
thấy cùng dữ liệu. Dùng cho bộ đếm, hàng đợi, dữ liệu số
chia sẻ giữa các luồng.','[]',1520,690),

('n_worker_vs_cluster','Worker Threads vs Cluster vs Child Process','System Design',
'Ba cách tách việc, chọn theo bài toán:

  worker_threads - đa LUỒNG trong 1 process, CHIA SẺ bộ nhớ,
    nhẹ.  -> việc CPU-bound (tính toán, mã hoá, xử lý ảnh).

  cluster - nhiều PROCESS cùng nghe 1 cổng, bộ nhớ tách
    biệt.  -> scale HTTP/I/O trên nhiều core (thường qua PM2).

  child_process - chạy chương trình/độc lập, cách ly hoàn
    toàn.  -> gọi lệnh hệ thống, chạy script bên ngoài.

Quy tắc nhanh:
  • Tính toán nặng             -> worker_threads
  • Phục vụ nhiều request/core -> cluster (hoặc PM2)
  • Gọi tool/lệnh bên ngoài    -> child_process','[]',1400,810),

-- ===== Section 7: Core Modules =====
('n_fs','fs — hệ thống file','Backend',
'Module fs có 3 kiểu API:
  • Đồng bộ:  fs.readFileSync (CHẶN loop; chỉ dùng lúc khởi
    động hoặc script nhỏ)
  • Callback: fs.readFile(path, cb) (err-first)
  • Promise:  fs.promises (nên dùng với async/await)

Ví dụ:
  const fs = require("fs/promises");
  const data = await fs.readFile("config.json", "utf8");
  await fs.writeFile("out.txt", "hello");

File lớn -> dùng stream thay vì đọc cả file:
  const fss = require("fs");
  fss.createReadStream("big.log").pipe(process.stdout);

Các thao tác fs chạy trên THREAD POOL của libuv (giới hạn
UV_THREADPOOL_SIZE). fs.watch theo dõi thay đổi file.','[]',500,890),

('n_http','http / https / net','Backend',
'Module http tạo server và client HTTP. req là Readable
stream, res là Writable stream.

Server:
  const http = require("http");
  http.createServer((req, res) => {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ ok: true }));
  }).listen(3000);

Client:
  http.get("http://api.local/ping", res => {
    let body = "";
    res.on("data", c => body += c);
    res.on("end", () => console.log(body));
  });

Express/Fastify xây trên http. net là tầng TCP thấp hơn;
http2 hỗ trợ multiplexing. Agent quản lý pool kết nối
(keep-alive) để tái dùng, giảm chi phí bắt tay TCP.','[]',620,890),

('n_crypto','crypto','Backend',
'crypto cung cấp hàm mã hoá/băm chuẩn — KHÔNG tự chế thuật
toán.

Băm (hash) và sinh ngẫu nhiên:
  const crypto = require("crypto");
  crypto.createHash("sha256").update("abc").digest("hex");
  crypto.randomUUID();                  // id ngẫu nhiên
  crypto.randomBytes(16).toString("hex");

Băm mật khẩu — dùng bản ASYNC vì nặng (chạy trên thread pool):
  crypto.scrypt(pw, salt, 64, (err, key) => { /* ... */ });
  // TRÁNH scryptSync trong request -> chặn loop

Ngoài ra: HMAC, mã hoá đối xứng (createCipheriv), ký/verify
bất đối xứng. Dùng randomBytes/randomUUID cho token; KHÔNG
dùng Math.random (không an toàn mật mã).','[]',500,1010),

('n_path_os','path, os, url','Backend',
'Nhóm module tiện ích đa nền tảng.

path — xử lý đường dẫn đúng trên cả Windows lẫn Linux:
  const path = require("path");
  path.join("a", "b", "c.txt");   // "a/b/c.txt"
  path.resolve("src", "app.js");  // đường dẫn tuyệt đối
  path.extname("a.png");          // ".png"
  path.basename("/x/y.txt");      // "y.txt"

os — thông tin hệ thống:
  const os = require("os");
  os.cpus().length;   // số core
  os.totalmem();      // tổng RAM
  os.platform();      // "linux" | "win32" | "darwin"

URL / URLSearchParams để phân tích & dựng URL. Luôn dùng
path.join thay vì tự nối chuỗi "/".','[]',620,1010),

('n_util','util & module tiện ích','Backend',
'util và vài module tiện ích hay dùng khi hiện đại hoá code.

util.promisify — biến hàm callback (err-first) thành Promise:
  const util = require("util");
  const fs = require("fs");
  const readFile = util.promisify(fs.readFile);
  const data = await readFile("a.txt", "utf8");

util.inspect — log object sâu, có màu:
  console.log(util.inspect(obj, { depth: null, colors: true }));

zlib — nén/giải nén (là Transform stream):
  const zlib = require("zlib");
  readable.pipe(zlib.createGzip()).pipe(writable);

timers/promises — setTimeout dạng Promise:
  import { setTimeout as sleep } from "timers/promises";
  await sleep(500);','[]',560,950),

-- ===== Section 8: Error Handling =====
('n_err_types','Operational vs Programmer errors','Backend',
'Phân loại lỗi để quyết định XỬ LÝ hay CRASH:

  • Operational error - lỗi vận hành DỰ ĐOÁN được: mất kết
    nối DB, timeout, input sai, hết dung lượng.
    -> nên bắt, log, retry hoặc trả lỗi cho client.
  • Programmer error - BUG trong code: gọi hàm trên
    undefined, quên await, sai kiểu.
    -> nên để tiến trình CRASH và restart sạch (fail fast),
       vì state đã không còn tin cậy.

Ví dụ:
  // operational: xử lý được
  try { await db.query(sql); }
  catch (e) { logger.warn(e); return res.status(503).end(); }

  // programmer: đừng nuốt, hãy sửa bug
  user.nmae;  // typo -> undefined, lỗi logic ngầm

Nuốt hết mọi lỗi khiến bug bị giấu và app chạy trong trạng
thái hỏng.','[]',1200,890),

('n_err_async','Bắt lỗi trong async','Backend',
'Cách bắt lỗi tuỳ kiểu bất đồng bộ:

  • async/await -> try/catch:
      try { const u = await getUser(id); }
      catch (e) { handle(e); }

  • Promise -> .catch():
      getUser(id).then(use).catch(handle);

  • Callback err-first -> kiểm tra tham số đầu:
      fs.readFile(p, (err, data) => {
        if (err) return handle(err);
      });

Bẫy hay gặp: QUÊN await -> lỗi thành unhandledRejection:
  async function f() { doAsync(); }  // thiếu await/return

Express 4: handler async phải next(err) hoặc dùng wrapper;
Express 5 tự bắt Promise reject.
Song song: Promise.all (fail-fast) vs Promise.allSettled
(trả về mọi kết quả kể cả lỗi).','[]',1320,890),

('n_err_global','uncaughtException & unhandledRejection','Backend',
'Hai lưới an toàn cuối cùng cho lỗi không bắt được:

  process.on("uncaughtException", err => {
    logger.fatal(err);
    process.exit(1);   // NÊN thoát: state không còn tin cậy
  });
  process.on("unhandledRejection", reason => {
    logger.error(reason);
    process.exit(1);
  });

• uncaughtException: lỗi đồng bộ không được try/catch.
• unhandledRejection: Promise reject không có .catch
  (từ Node 15 mặc định làm crash tiến trình).

Triết lý: đừng dùng chúng để "chạy tiếp như chưa có gì".
Hãy log rồi để process manager (PM2 / Kubernetes) restart
tiến trình sạch — an toàn hơn là cố phục hồi.','[]',1200,950),

('n_als','AsyncLocalStorage','Backend',
'AsyncLocalStorage lưu context xuyên suốt một chuỗi bất
đồng bộ mà KHÔNG phải truyền tham số thủ công qua từng hàm
— giống thread-local storage. Xây trên async_hooks.

Ví dụ gắn correlation id cho mỗi request để log:
  const { AsyncLocalStorage } = require("async_hooks");
  const als = new AsyncLocalStorage();

  app.use((req, res, next) => {
    als.run({ reqId: crypto.randomUUID() }, () => next());
  });

  function log(msg) {
    const store = als.getStore();
    console.log(`[${store?.reqId}] ${msg}`);
  }
  // mọi hàm await sâu bên trong vẫn thấy đúng reqId

Dùng cho logging tương quan, tracing, multi-tenant. Có chút
chi phí hiệu năng nhưng thường chấp nhận được.','[]',1320,950),

-- ===== Section 9: V8 & Memory =====
('n_v8','V8 & biên dịch JIT','DevOps & Cloud',
'V8 là engine chạy JS của Node (cùng engine với Chrome).
Quy trình biên dịch:
  mã JS -> parse (AST) -> bytecode (Ignition)
        -> mã máy tối ưu (TurboFan) cho đoạn code NÓNG
        -> có thể de-optimize khi kiểu dữ liệu đổi bất ngờ

Mẹo giúp V8 tối ưu (giữ hidden class ổn định):
  // TỐT: hình dạng object nhất quán
  function P(x, y) { this.x = x; this.y = y; }
  const p = new P(1, 2);
  // XẤU: thêm field sau đó -> đổi shape -> chậm hơn
  p.z = 3;

Hệ quả thực tế: khởi tạo object cùng thứ tự field, tránh
đổi kiểu biến, tránh delete property trong vòng lặp nóng.
Cờ tinh chỉnh: node --v8-options.','[]',850,1010),

('n_gc','Garbage Collection & Heap','DevOps & Cloud',
'V8 gom rác (GC) theo THẾ HỆ vì đa số object chết trẻ:
  • Young generation - object mới; thu bằng Scavenger,
    nhanh, chạy thường xuyên.
  • Old generation   - object sống lâu; thu bằng
    Mark-Sweep-Compact, chậm hơn.
GC gây dừng luồng (stop-the-world) trong thời gian ngắn.

Heap có GIỚI HẠN mặc định (~vài GB tuỳ phiên bản), chỉnh:
  node --max-old-space-size=4096 app.js   // 4GB

Ví dụ chủ động (chỉ khi chạy với --expose-gc, dùng để test):
  if (global.gc) global.gc();

Object còn được tham chiếu thì KHÔNG bị thu -> giữ tham
chiếu ngoài ý muốn chính là memory leak (xem node kế).','[]',970,1010),

('n_memory','Memory leak & chẩn đoán','DevOps & Cloud',
'Memory leak trong app chạy lâu: heap tăng dần rồi OOM.
Nguyên nhân phổ biến:
  • biến/global tích luỹ (cache không giới hạn)
  • listener EventEmitter không gỡ
  • closure giữ tham chiếu lớn
  • timer (setInterval) không clear

Ví dụ leak điển hình:
  const cache = {};
  app.get("/u/:id", (req, res) => {
    cache[req.params.id] = bigObject;  // không bao giờ xoá
  });                                   // -> phình mãi

Phát hiện:
  console.log(process.memoryUsage().heapUsed); // theo dõi tăng
  // chụp heap snapshot: node --inspect + Chrome DevTools
  // hoặc cờ --heapsnapshot-near-heap-limit

Giải pháp cache: dùng LRU có giới hạn kích thước.','[]',850,1070),

('n_perf','Đo hiệu năng: perf_hooks & profiling','DevOps & Cloud',
'Đo TRƯỚC khi tối ưu — đừng đoán. Công cụ tích hợp:

perf_hooks — đo thời gian & độ trễ event loop:
  const { performance, monitorEventLoopDelay } =
    require("perf_hooks");
  const t = performance.now();
  doWork();
  console.log(performance.now() - t, "ms");

  const h = monitorEventLoopDelay(); h.enable();
  // sau một lúc: h.mean, h.max -> độ trễ loop (ns)

Profiling CPU:
  node --prof app.js     // sinh isolate log để phân tích
  node --inspect app.js  // gắn Chrome DevTools
  // hoặc clinic.js, 0x (vẽ flamegraph)

Quy trình: đo -> tìm điểm nóng thật -> tối ưu đúng chỗ ->
đo lại để xác nhận.','[]',970,1070)
ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), links=VALUES(links);

-- ------------------------- EDGES -----------------------------------
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_ndc_part-of','root','t_ndc','part-of'),
('e_t_ndc_t_nodejs_related','t_ndc','t_nodejs','related'),
('e_t_ndc_s_ndc_1_part-of','t_ndc','s_ndc_1','part-of'),
('e_t_ndc_s_ndc_2_part-of','t_ndc','s_ndc_2','part-of'),
('e_t_ndc_s_ndc_3_part-of','t_ndc','s_ndc_3','part-of'),
('e_t_ndc_s_ndc_4_part-of','t_ndc','s_ndc_4','part-of'),
('e_t_ndc_s_ndc_5_part-of','t_ndc','s_ndc_5','part-of'),
('e_t_ndc_s_ndc_6_part-of','t_ndc','s_ndc_6','part-of'),
('e_t_ndc_s_ndc_7_part-of','t_ndc','s_ndc_7','part-of'),
('e_t_ndc_s_ndc_8_part-of','t_ndc','s_ndc_8','part-of'),
('e_t_ndc_s_ndc_9_part-of','t_ndc','s_ndc_9','part-of'),
('e_s_ndc_1_n_el_arch_part-of','s_ndc_1','n_el_arch','part-of'),
('e_s_ndc_1_n_el_phases_part-of','s_ndc_1','n_el_phases','part-of'),
('e_s_ndc_1_n_el_micro_macro_part-of','s_ndc_1','n_el_micro_macro','part-of'),
('e_s_ndc_1_n_el_nexttick_part-of','s_ndc_1','n_el_nexttick','part-of'),
('e_s_ndc_1_n_el_timers_part-of','s_ndc_1','n_el_timers','part-of'),
('e_s_ndc_1_n_el_blocking_part-of','s_ndc_1','n_el_blocking','part-of'),
('e_s_ndc_2_n_mod_cjs_part-of','s_ndc_2','n_mod_cjs','part-of'),
('e_s_ndc_2_n_mod_wrapper_part-of','s_ndc_2','n_mod_wrapper','part-of'),
('e_s_ndc_2_n_mod_resolution_part-of','s_ndc_2','n_mod_resolution','part-of'),
('e_s_ndc_2_n_mod_esm_part-of','s_ndc_2','n_mod_esm','part-of'),
('e_s_ndc_2_n_mod_interop_part-of','s_ndc_2','n_mod_interop','part-of'),
('e_s_ndc_3_n_stream_types_part-of','s_ndc_3','n_stream_types','part-of'),
('e_s_ndc_3_n_stream_backpressure_part-of','s_ndc_3','n_stream_backpressure','part-of'),
('e_s_ndc_3_n_stream_modes_part-of','s_ndc_3','n_stream_modes','part-of'),
('e_s_ndc_3_n_buffer_part-of','s_ndc_3','n_buffer','part-of'),
('e_s_ndc_4_n_ee_basic_part-of','s_ndc_4','n_ee_basic','part-of'),
('e_s_ndc_4_n_ee_leak_part-of','s_ndc_4','n_ee_leak','part-of'),
('e_s_ndc_5_n_process_obj_part-of','s_ndc_5','n_process_obj','part-of'),
('e_s_ndc_5_n_child_process_part-of','s_ndc_5','n_child_process','part-of'),
('e_s_ndc_5_n_cluster_part-of','s_ndc_5','n_cluster','part-of'),
('e_s_ndc_5_n_signals_part-of','s_ndc_5','n_signals','part-of'),
('e_s_ndc_6_n_worker_threads_part-of','s_ndc_6','n_worker_threads','part-of'),
('e_s_ndc_6_n_shared_mem_part-of','s_ndc_6','n_shared_mem','part-of'),
('e_s_ndc_6_n_worker_vs_cluster_part-of','s_ndc_6','n_worker_vs_cluster','part-of'),
('e_s_ndc_7_n_fs_part-of','s_ndc_7','n_fs','part-of'),
('e_s_ndc_7_n_http_part-of','s_ndc_7','n_http','part-of'),
('e_s_ndc_7_n_crypto_part-of','s_ndc_7','n_crypto','part-of'),
('e_s_ndc_7_n_path_os_part-of','s_ndc_7','n_path_os','part-of'),
('e_s_ndc_7_n_util_part-of','s_ndc_7','n_util','part-of'),
('e_s_ndc_8_n_err_types_part-of','s_ndc_8','n_err_types','part-of'),
('e_s_ndc_8_n_err_async_part-of','s_ndc_8','n_err_async','part-of'),
('e_s_ndc_8_n_err_global_part-of','s_ndc_8','n_err_global','part-of'),
('e_s_ndc_8_n_als_part-of','s_ndc_8','n_als','part-of'),
('e_s_ndc_9_n_v8_part-of','s_ndc_9','n_v8','part-of'),
('e_s_ndc_9_n_gc_part-of','s_ndc_9','n_gc','part-of'),
('e_s_ndc_9_n_memory_part-of','s_ndc_9','n_memory','part-of'),
('e_s_ndc_9_n_perf_part-of','s_ndc_9','n_perf','part-of'),
('e_n_el_phases_q_1_related','n_el_phases','q_1','related'),
('e_n_mod_cjs_q_4_related','n_mod_cjs','q_4','related'),
('e_n_err_async_q_3_related','n_err_async','q_3','related'),
('e_n_el_blocking_q_11_related','n_el_blocking','q_11','related'),
('e_n_cluster_q_11_related','n_cluster','q_11','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);


-- ===================================================================
--  BỔ SUNG NÂNG CAO: Event Loop/libuv deep dive — xem seed_nodejs_advanced.sql
-- ===================================================================
-- ------------------------- NODES -----------------------------------
INSERT INTO kg_nodes (id,label,category,description,links,pos_x,pos_y) VALUES
('s_ndc_10','Deep Dive: Event Loop & libuv','Backend','Đào sâu cơ chế bên dưới kèm sơ đồ: libuv là gì và hoạt động ra sao, event loop chạy từng tick thế nào, phân biệt event loop với các queue, poll phase, thread pool, non-blocking I/O ở tầng OS và ý nghĩa "single-threaded".','[]',750,300),
('s_ndc_11','Deep Dive: Vòng đời request & Thứ tự thực thi','Backend','Trace một HTTP request từ kernel tới response, và thứ tự thực thi chính xác giữa nextTick, Promise microtask, timers và I/O — kèm sơ đồ, ví dụ code và các bẫy thường gặp.','[]',1150,300),

-- ===== Section 10: Event Loop & libuv (internals) =====
('n_dd_libuv','libuv là gì và hoạt động thế nào?','Backend',
'libuv là một thư viện C đa nền tảng, cung cấp EVENT LOOP và
I/O bất đồng bộ cho Node.js. Vai trò cốt lõi: che giấu sự
khác biệt của cơ chế I/O ở từng hệ điều hành sau MỘT API
chung — nó bọc epoll (Linux), kqueue (macOS/BSD), IOCP
(Windows).

SƠ ĐỒ — khi bạn gọi một API bất đồng bộ:

  Code JS của bạn (chạy trên V8, 1 luồng)
    │  ví dụ: fs.readFile(), db.query(), crypto.pbkdf2()
    ▼
  Node.js C++ bindings
    │
    ▼
  libuv  ── chia việc thành 2 hướng:
    │
    ├─► EVENT LOOP (luồng chính)
    │     • dùng cho I/O MẠNG (TCP/UDP/pipe)
    │     • qua epoll / kqueue / IOCP
    │     • 1 luồng theo dõi hàng nghìn socket
    │
    └─► THREAD POOL (mặc định 4 luồng)
          • cho việc KHÔNG có async ở kernel:
            fs.* (file), dns.lookup,
            crypto nặng (pbkdf2/scrypt), zlib
          • chạy blocking ở luồng phụ rồi
            trả kết quả ngược về event loop

ĐIỂM MẤU CHỐT (hay bị hiểu sai):
• I/O mạng KHÔNG dùng thread pool. libuv dùng trực tiếp
  socket non-blocking + epoll của kernel, chỉ bằng ĐÚNG
  MỘT luồng.
• Chỉ file I/O, DNS lookup, crypto nặng, zlib mới bị đẩy
  sang thread pool — vì trên đa số OS chúng không có API
  bất đồng bộ thật ở tầng kernel.

Chỉnh số luồng pool bằng biến môi trường UV_THREADPOOL_SIZE
(đặt TRƯỚC khi Node khởi động, tối đa 1024).','[]',650,180),

('n_dd_eventloop_detail','Event loop chạy chi tiết một vòng (tick) như thế nào?','Backend',
'Event loop là vòng lặp vô hạn do libuv chạy trên luồng
chính. Mỗi lần lặp gọi là một TICK, đi qua các phase theo
thứ tự CỐ ĐỊNH; mỗi phase có một hàng đợi callback riêng
(FIFO).

SƠ ĐỒ một tick:

  ┌─► (1) timers        → cb setTimeout/setInterval đến hạn
  │   (2) pending cbs   → vài callback I/O hoãn từ vòng trước
  │   (3) idle/prepare  → nội bộ libuv
  │   (4) poll   ★★★    → lấy sự kiện I/O từ kernel,
  │                       chạy callback I/O (đọc socket...)
  │   (5) check         → callback setImmediate
  │   (6) close cbs     → ví dụ socket.on("close")
  │        │
  └────────┘  hết phase 6 thì quay lại phase 1 (tick mới)

  ⚡ Sau MỖI callback và giữa MỖI phase, Node xả microtask:
       1. nextTick queue   → xả cho tới RỖNG
       2. Promise queue    → xả cho tới RỖNG
     rồi mới chạy callback / phase tiếp theo.

Ý nghĩa từng phase:
• timers: kiểm tra đồng hồ, chạy các timer đã quá hạn.
• pending callbacks: một số lỗi/hoàn tất I/O của hệ thống
  bị hoãn (ví dụ ECONNREFUSED của TCP).
• poll: trái tim của loop — chạy callback I/O đã sẵn sàng
  và quyết định có ngủ chờ I/O hay không.
• check: nơi setImmediate chạy, ngay sau poll.
• close: dọn dẹp, phát sự kiện đóng.

Loop KẾT THÚC khi không còn handle/request nào active
(không còn timer, socket hay callback đang chờ) — lúc đó
tiến trình Node thoát.','[]',770,180),

('n_dd_loop_vs_queue','Phân biệt Event Loop và Queue (có sơ đồ)','Backend',
'Nhầm lẫn phổ biến: nghĩ rằng chỉ có "một cái callback
queue". Thực tế event loop KHÔNG phải một hàng đợi, mà là
bộ ĐIỀU PHỐI; và có NHIỀU hàng đợi.

SƠ ĐỒ:

  EVENT LOOP = bộ điều phối (scheduler)
  │  nó lần lượt ghé từng phase; mỗi phase có 1 queue riêng:
  │
  ├─ timers queue      [ cb, cb, ... ]   (macrotask)
  ├─ pending queue     [ ... ]           (macrotask)
  ├─ poll / IO queue   [ ... ]           (macrotask)
  ├─ check queue       [ setImmediate ]  (macrotask)
  └─ close queue       [ ... ]           (macrotask)

  NGOÀI các phase, có 2 queue MICROTASK ưu tiên cao:
  ├─ nextTick queue    → xả TRƯỚC  (ưu tiên 1)
  └─ Promise queue     → xả SAU    (ưu tiên 2)

CÁCH GHÉP LẠI:
  chọn 1 phase → chạy hết queue của phase đó
    → xả hết nextTick queue
    → xả hết Promise queue
    → sang phase kế tiếp

Tóm lại:
• Event loop = người điều phối, quyết định "chạy cái gì,
  khi nào".
• Queue = nơi callback xếp hàng chờ.
Cái mà nhiều sơ đồ đơn giản gọi chung là "callback queue"
thực chất là NHIỀU queue tách theo từng phase, cộng thêm 2
queue microtask riêng.','[]',890,180),

('n_dd_poll','Poll phase — trái tim của event loop (cây quyết định)','Backend',
'Poll là phase quan trọng nhất, làm hai việc: (1) chạy
callback cho các sự kiện I/O đã hoàn tất; (2) quyết định
event loop có NGỦ (block) hay không, và bao lâu.

CÂY QUYẾT ĐỊNH khi vào POLL:

  Vào POLL phase
  │
  ├─ poll queue CÓ callback?
  │     └─ CÓ → chạy hết callback (tới giới hạn hệ thống)
  │             rồi đi tiếp sang check phase
  │
  └─ poll queue RỖNG?
        ├─ có setImmediate đang chờ?
        │     └─ KHÔNG ngủ → nhảy sang CHECK phase ngay
        │
        ├─ có timer sắp đến hạn?
        │     └─ ngủ TỐI ĐA tới thời điểm timer gần nhất,
        │        rồi quay lại TIMERS phase
        │
        └─ không có gì cả?
              └─ ngủ chờ I/O (epoll_wait) tới khi
                 kernel báo có sự kiện

Ý NGHĨA:
• Đây là lý do Node "ngủ" khi rảnh thay vì quay vòng đốt
  CPU (busy-wait) — hiệu quả năng lượng và CPU.
• Cũng giải thích vì sao thứ tự setTimeout(0) so với
  setImmediate là KHÔNG xác định khi gọi ở top-level (tùy
  loop có kịp bước qua ngưỡng ~1ms của timer hay chưa).','[]',650,240),

('n_dd_threadpool','Thread pool của libuv — cái gì chạy trên đó?','Backend',
'Thread pool của libuv mặc định có 4 luồng (chỉnh bằng
UV_THREADPOOL_SIZE, đặt TRƯỚC khi Node khởi động, tối đa
1024). Nó phục vụ các tác vụ blocking không có async ở
kernel.

SƠ ĐỒ:

  EVENT LOOP ──giao việc──► THREAD POOL (mặc định 4 luồng)
                             ├─ luồng #1  [bận: đọc file A]
                             ├─ luồng #2  [bận: pbkdf2]
                             ├─ luồng #3  [rảnh]
                             └─ luồng #4  [rảnh]
                                   │
                     xong việc ────┘
                             │
  EVENT LOOP ◄──đẩy kết quả về──┘  (callback vào phase phù hợp)

CÁI GÌ DÙNG THREAD POOL:
• fs.*  — đọc/ghi file (file I/O không non-blocking thật
  trên đa số OS).
• dns.lookup (getaddrinfo). Lưu ý: dns.resolve dùng mạng
  nên KHÔNG qua pool.
• crypto nặng: pbkdf2, scrypt, randomBytes (bản async),
  một phần TLS.
• zlib — nén/giải nén.

BẪY THỰC TẾ (hay bị bỏ sót):
Pool chỉ có 4 luồng. Nếu có 5 tác vụ nặng (ví dụ 5 lời gọi
pbkdf2) chạy đồng thời, tác vụ thứ 5 phải CHỜ một luồng
rảnh → xuất hiện độ trễ khó hiểu dù CPU còn rảnh. Cách xử
lý: tăng UV_THREADPOOL_SIZE hợp lý (thường bám theo số CPU
core), hoặc đẩy tính toán nặng sang Worker Threads.','[]',770,240),

('n_dd_nonblocking_os','Non-blocking I/O ở tầng OS: epoll / kqueue / IOCP','Backend',
'Node đạt hiệu năng I/O cao nhờ tận dụng cơ chế I/O bất
đồng bộ của kernel. Có HAI mô hình:

MÔ HÌNH 1 — READINESS (Linux epoll, macOS/BSD kqueue):
  App: "báo tôi khi socket này ĐỌC được"
    │  → đăng ký fd vào epoll
    ▼
  Kernel: (khi có data) "fd đã SẴN SÀNG"
    │
    ▼
  App: tự gọi read() non-blocking để lấy data

MÔ HÌNH 2 — COMPLETION (Windows IOCP):
  App: "đọc socket này giùm tôi"  → gửi yêu cầu
    │
    ▼
  Kernel: tự đọc xong  → "ĐÃ HOÀN TẤT, đây là data"

libuv trừu tượng cả hai sau một API chung.

VÌ SAO QUAN TRỌNG — so sánh mô hình phục vụ:

  Kiểu cũ (Apache/PHP truyền thống):
    1 kết nối = 1 thread (hoặc process)
    10.000 kết nối → 10.000 thread
    → tốn RAM, context-switch nặng, khó scale

  Kiểu Node (epoll):
    1 luồng dùng epoll theo dõi TẤT CẢ fd
    10.000 kết nối → 1 luồng + 1 danh sách fd
    → rất nhẹ (đây chính là bài toán C10K)

Với mạng, libuv dùng đúng epoll/kqueue/IOCP (1 luồng). Với
file, do giới hạn OS, libuv GIẢ LẬP async bằng thread pool.','[]',890,240),

('n_dd_singlethread','Vì sao "single-threaded" mà vẫn xử lý đồng thời?','Backend',
'Node là single-threaded ở chỗ: code JS CỦA BẠN chạy trên
MỘT luồng (main thread) — không bao giờ có hai đoạn JS chạy
song song, nên biến thường không cần lock/mutex. Nhưng nó
vẫn ĐỒNG THỜI nhờ offload I/O cho kernel/thread pool.

PHÂN BIỆT 2 KHÁI NIỆM (kèm sơ đồ):

  CONCURRENCY — xử lý xen kẽ trên 1 luồng (Node rất giỏi):
    req A ──gọi DB──▶ (đang chờ DB...)
    req B ─────────▶ được xử lý trong lúc A chờ
    req A ◀─DB xong─ chạy tiếp phần sau
    → 1 luồng, không ai ngồi chờ không

  PARALLELISM — chạy thật song song (cần Worker/cluster):
    core 1: ████ task 1
    core 2: ████ task 2   ← cùng thời điểm

HỆ QUẢ:
• Node cực mạnh với tải I/O-BOUND (API gọi DB/mạng/file):
  trong lúc chờ I/O, luồng JS đi làm việc khác.
• Với tải CPU-BOUND (tính toán nặng, vòng lặp lớn, mã hóa
  đồng bộ): luồng JS bị CHẶN, mọi request khác phải chờ →
  cần đẩy sang Worker Threads hoặc cluster để có
  parallelism thật.','[]',770,300),

-- ===== Section 11: Vòng đời request & Thứ tự thực thi =====
('n_dd_request_lifecycle','Luồng chạy của một HTTP request vào Node.js (từ A đến Z)','Backend',
'Trace đầy đủ một request GET đi vào server http/Express,
từ gói tin TCP tới lúc client nhận response.

SƠ ĐỒ THỜI GIAN:

  CLIENT
    │ (1) gửi HTTP request (gói TCP)
    ▼
  KERNEL ── đánh dấu socket readable ──► epoll báo cho libuv
    │
    ▼
  (2) POLL phase: libuv đọc bytes,
      llhttp parse HTTP
      → tạo req (IncomingMessage = Readable stream)
      → tạo res (ServerResponse = Writable stream)
    │
    ▼
  (3) V8 chạy handler JS của bạn (đồng bộ, 1 luồng)
    │  ví dụ: app.get("/x", async (req,res) => { ... })
    ▼
  (4) handler gọi I/O:  await db.query(...)
    │  → lệnh gửi qua socket DB, handler RETURN NGAY
    │  → luồng chính RẢNH, phục vụ request khác
    ⋮   ... event loop tiếp tục quay các vòng khác ...
    ▼
  (5) DB trả kết quả → socket DB readable
    │  → POLL phase chạy callback
    │  → Promise resolve → code sau await vào
    │    microtask queue → chạy nốt
    ▼
  (6) res.json(...) / res.end()
    │  → ghi data ra socket (non-blocking)
    │  → nếu buffer đầy: chờ sự kiện "drain" (backpressure)
    ▼
  KERNEL gửi gói TCP về CLIENT
    │
    ▼
  (7) keep-alive (giữ socket tái dùng)
      hoặc close (chạy ở close-callbacks phase)

ĐIỂM CỐT LÕI: bước (4)-(5) là lý do MỘT luồng phục vụ được
hàng nghìn request đan xen — trong lúc request này chờ I/O,
luồng đi xử lý request khác thay vì đứng chờ.','[]',1050,180),

('n_dd_exec_order','Thứ tự thực thi: nextTick vs Promise vs timer vs I/O','Backend',
'Quy tắc vàng: sau MỖI callback và giữa mỗi phase, Node xả
HẾT nextTick queue → rồi HẾT Promise microtask queue → mới
chạy macrotask kế tiếp.

VÍ DỤ KINH ĐIỂN:
  console.log("1");
  setTimeout(() => console.log("2 timeout"), 0);
  setImmediate(() => console.log("3 immediate"));
  Promise.resolve().then(() => console.log("4 promise"));
  process.nextTick(() => console.log("5 nextTick"));
  console.log("6");

TRACE TỪNG BƯỚC:

  ◆ Pha đồng bộ (chạy tuần tự ngay):
      in "1"
      đăng ký timeout   → timers queue:  [2]
      đăng ký immediate → check queue:   [3]
      đăng ký .then     → Promise queue: [4]
      đăng ký nextTick  → nextTick queue:[5]
      in "6"

  ◆ Hết đồng bộ → xả microtask:
      nextTick queue trước → in "5"
      Promise queue sau    → in "4"

  ◆ Vào event loop (các phase):
      timers phase → in "2"
      check  phase → in "3"

  ➜ KẾT QUẢ:  1  6  5  4  2  3

GHI CHÚ:
• Mã đồng bộ luôn xong trước (1, 6).
• nextTick (5) luôn trước Promise (4); cả hai luôn trước
  timer/immediate.
• Ở top-level, thứ tự 2 (timeout) vs 3 (immediate) KHÔNG
  đảm bảo; nhưng nếu đặt trong một callback I/O thì 3
  (immediate) luôn trước.','[]',1170,180),

('n_dd_timeout_immediate','setTimeout(0) vs setImmediate: ai chạy trước?','Backend',
'Kết quả phụ thuộc bạn gọi chúng Ở ĐÂU trong chu kỳ event
loop.

VỊ TRÍ TRONG MỘT VÒNG LOOP:

  ... → poll ──▶ check ──▶ (vòng mới) timers → ...
                  ▲                      ▲
           setImmediate            setTimeout(0)

  → Đứng ở poll (nơi callback I/O chạy), phase NGAY SAU là
    check. Vì vậy TRONG một callback I/O: setImmediate luôn
    chạy TRƯỚC setTimeout(0), còn timers phải chờ tới vòng
    lặp kế tiếp.

TRƯỜNG HỢP 1 — trong callback I/O (kết quả XÁC ĐỊNH):
  const fs = require("fs");
  fs.readFile(__filename, () => {
    setTimeout(() => console.log("timeout"), 0);
    setImmediate(() => console.log("immediate"));
  });
  // LUÔN in:  immediate  →  timeout

TRƯỜNG HỢP 2 — ở top-level (kết quả KHÔNG xác định):
  setTimeout(() => console.log("timeout"), 0);
  setImmediate(() => console.log("immediate"));
  // Thứ tự có thể đổi mỗi lần chạy, vì setTimeout(0) thực
  // chất có ngưỡng tối thiểu ~1ms; tùy loop có kịp qua
  // ngưỡng đó chưa.

KẾT LUẬN THỰC DỤNG:
Muốn "chạy ngay sau khi I/O hiện tại xong" thì dùng
setImmediate — nó có vị trí xác định trong chu kỳ;
setTimeout(0) thì không.','[]',1290,180),

('n_dd_async_await_compile','async/await dưới góc nhìn engine (V8 & microtask)','Backend',
'async/await chỉ là cú pháp trên nền Promise. Hiểu được nó
"biên dịch" thành gì sẽ giải thích chính xác thứ tự chạy.

KHI GẶP await:
• Hàm async TẠM DỪNG tại điểm await và trả về một Promise
  cho caller NGAY (không chặn luồng).
• Toàn bộ code SAU await được đăng ký như một MICROTASK,
  chỉ chạy khi Promise được await đã resolve.

MINH HỌA — hai đoạn sau tương đương:

  // Viết bằng async/await:
  async function f() {
    console.log("A");
    await something;        // ◄ ĐIỂM CẮT
    console.log("B");       // ◄ phần này thành microtask
  }

  // Tương đương (đơn giản hoá):
  function f() {
    console.log("A");
    return Promise.resolve(something).then(() => {
      console.log("B");
    });
  }

  → "A" chạy ĐỒNG BỘ; "B" bị HOÃN vào microtask queue —
    kể cả khi something đã sẵn sàng (await 5 vẫn hoãn "B").

HỆ QUẢ:
• await luôn nhường cho event loop ít nhất một lượt
  microtask.
• Một chuỗi async/await thực chất là các microtask nối
  tiếp nhau → chúng LUÔN chạy trước setTimeout/setImmediate
  của cùng lượt.
• V8 hiện đại đã tối ưu để await một Promise gốc không tạo
  Promise trung gian dư thừa.','[]',1050,240),

('n_dd_promise_microtask','Promise resolve đi vào microtask queue ra sao?','Backend',
'Khi một Promise chuyển trạng thái, các callback
.then/.catch/.finally KHÔNG chạy ngay mà được đẩy vào
MICROTASK QUEUE (PromiseJobs của V8).

SƠ ĐỒ VÒNG ĐỜI:

  Promise (pending)
    │  resolve(value)
    ▼
  Promise (fulfilled)
    │  đẩy các .then callback vào MICROTASK QUEUE
    │  (KHÔNG chạy ngay tại chỗ)
    ▼
  Event loop: sau mỗi macrotask/phase → xả microtask queue
    │  nếu callback lại tạo microtask mới
    │  → xả luôn trong CÙNG lượt
    ▼
  ... lặp cho tới khi queue RỖNG mới đi tiếp phase khác

HAI QUEUE MICROTASK CỦA NODE (thứ tự xả):
  ├─ nextTick queue   → xả TRƯỚC (đặc thù Node, không có
  │                      trong chuẩn JS)
  └─ Promise queue    → xả SAU

CÔNG CỤ & LƯU Ý:
• queueMicrotask(fn) cho phép tự đẩy hàm vào đúng Promise
  microtask queue.
• Vì microtask được xả tới RỖNG, một chuỗi microtask quá
  dài (hoặc tự sinh vô hạn) có thể trì hoãn I/O và timer —
  xem node "starvation".','[]',1170,240),

('n_dd_starvation','Đói I/O do nextTick / microtask (starvation)','Backend',
'Vì Node xả TOÀN BỘ nextTick queue (rồi tới Promise queue)
trước khi cho event loop đi tiếp, một callback liên tục tự
lên lịch lại bằng nextTick (hoặc đệ quy microtask) sẽ khiến
loop KHÔNG BAO GIỜ tới poll phase → I/O và timer bị bỏ đói,
app như bị "treo" dù CPU không nặng.

SƠ ĐỒ SO SÁNH:

  ✗ SAI — kẹt event loop (starvation):
      function loop() { process.nextTick(loop); }
      loop();

      nextTick queue KHÔNG BAO GIỜ rỗng
        → xả microtask mãi không hết
        → loop không tới được poll phase
        → mọi I/O / timer bị bỏ đói → app treo

  ✓ ĐÚNG — nhường I/O:
      function loop() { setImmediate(loop); }
      loop();

      setImmediate chạy ở check phase
        → giữa mỗi lần lặp, loop VẪN ghé qua poll
        → I/O và timer vẫn được phục vụ

KẾT LUẬN:
Đây là khác biệt THỰC TẾ quan trọng nhất giữa
process.nextTick và setImmediate:
• nextTick = "chen ngay lập tức", dễ gây đói I/O nếu lạm
  dụng/đệ quy.
• setImmediate = "chờ tới lượt sau poll", an toàn cho vòng
  lặp cần nhường I/O.','[]',1290,240)
ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), links=VALUES(links);

-- ------------------------- EDGES -----------------------------------
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_t_ndc_s_ndc_10_part-of','t_ndc','s_ndc_10','part-of'),
('e_t_ndc_s_ndc_11_part-of','t_ndc','s_ndc_11','part-of'),
('e_s_ndc_10_n_dd_libuv_part-of','s_ndc_10','n_dd_libuv','part-of'),
('e_s_ndc_10_n_dd_eventloop_detail_part-of','s_ndc_10','n_dd_eventloop_detail','part-of'),
('e_s_ndc_10_n_dd_loop_vs_queue_part-of','s_ndc_10','n_dd_loop_vs_queue','part-of'),
('e_s_ndc_10_n_dd_poll_part-of','s_ndc_10','n_dd_poll','part-of'),
('e_s_ndc_10_n_dd_threadpool_part-of','s_ndc_10','n_dd_threadpool','part-of'),
('e_s_ndc_10_n_dd_nonblocking_os_part-of','s_ndc_10','n_dd_nonblocking_os','part-of'),
('e_s_ndc_10_n_dd_singlethread_part-of','s_ndc_10','n_dd_singlethread','part-of'),
('e_s_ndc_11_n_dd_request_lifecycle_part-of','s_ndc_11','n_dd_request_lifecycle','part-of'),
('e_s_ndc_11_n_dd_exec_order_part-of','s_ndc_11','n_dd_exec_order','part-of'),
('e_s_ndc_11_n_dd_timeout_immediate_part-of','s_ndc_11','n_dd_timeout_immediate','part-of'),
('e_s_ndc_11_n_dd_async_await_compile_part-of','s_ndc_11','n_dd_async_await_compile','part-of'),
('e_s_ndc_11_n_dd_promise_microtask_part-of','s_ndc_11','n_dd_promise_microtask','part-of'),
('e_s_ndc_11_n_dd_starvation_part-of','s_ndc_11','n_dd_starvation','part-of'),
('e_n_dd_libuv_n_el_arch_related','n_dd_libuv','n_el_arch','related'),
('e_n_dd_eventloop_detail_n_el_phases_related','n_dd_eventloop_detail','n_el_phases','related'),
('e_n_dd_eventloop_detail_q_1_related','n_dd_eventloop_detail','q_1','related'),
('e_n_dd_loop_vs_queue_n_el_micro_macro_related','n_dd_loop_vs_queue','n_el_micro_macro','related'),
('e_n_dd_threadpool_n_fs_related','n_dd_threadpool','n_fs','related'),
('e_n_dd_poll_n_el_phases_related','n_dd_poll','n_el_phases','related'),
('e_n_dd_singlethread_n_worker_vs_cluster_related','n_dd_singlethread','n_worker_vs_cluster','related'),
('e_n_dd_exec_order_n_el_nexttick_related','n_dd_exec_order','n_el_nexttick','related'),
('e_n_dd_timeout_immediate_n_el_timers_related','n_dd_timeout_immediate','n_el_timers','related'),
('e_n_dd_starvation_n_el_nexttick_related','n_dd_starvation','n_el_nexttick','related'),
('e_n_dd_request_lifecycle_n_http_related','n_dd_request_lifecycle','n_http','related'),
('e_n_dd_async_await_compile_q_3_related','n_dd_async_await_compile','q_3','related'),
('e_n_dd_promise_microtask_n_el_micro_macro_related','n_dd_promise_microtask','n_el_micro_macro','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);


-- ===================================================================
--  BẢN DỊCH TIẾNG ANH (description_en) — xem seed_nodejs_en.sql
-- ===================================================================
-- Topic + sections
UPDATE kg_nodes SET description_en='In-depth knowledge of the Node.js core: Event Loop/libuv, module system, streams, EventEmitter, multi-process and multi-thread, core modules, error handling, and V8/memory. Goal: understand the runtime deeply to answer Senior interview questions.' WHERE id='t_ndc';
UPDATE kg_nodes SET description_en='How Node handles non-blocking I/O: runtime architecture, event loop phases, micro/macrotasks, and how to avoid blocking the thread.' WHERE id='s_ndc_1';
UPDATE kg_nodes SET description_en='The two module systems of Node: how modules load, cache, resolve paths, and how CommonJS and ES Modules interoperate.' WHERE id='s_ndc_2';
UPDATE kg_nodes SET description_en='Processing data as streams to save memory: stream types, backpressure, modes, and the binary Buffer.' WHERE id='s_ndc_3';
UPDATE kg_nodes SET description_en='The publish/subscribe event model - the foundation of many core APIs (stream, http, process).' WHERE id='s_ndc_4';
UPDATE kg_nodes SET description_en='The process object, spawning child processes, and forking processes to use multiple CPU cores.' WHERE id='s_ndc_5';
UPDATE kg_nodes SET description_en='Running JS in parallel within one process for CPU-bound tasks; sharing memory safely.' WHERE id='s_ndc_6';
UPDATE kg_nodes SET description_en='Frequently used core modules and how they interact with the event loop / thread pool.' WHERE id='s_ndc_7';
UPDATE kg_nodes SET description_en='Error classification, catching errors in async code, global error handling, and passing context across async chains.' WHERE id='s_ndc_8';
UPDATE kg_nodes SET description_en='The V8 engine, garbage collection, memory leaks, and how to measure/optimize performance.' WHERE id='s_ndc_9';
UPDATE kg_nodes SET description_en='Deep dive into the internals with diagrams: what libuv is and how it works, how the event loop runs each tick, event loop vs queues, poll phase, thread pool, non-blocking I/O at the OS level, and what single-threaded means.' WHERE id='s_ndc_10';
UPDATE kg_nodes SET description_en='Trace an HTTP request from the kernel to the response, and the exact execution order between nextTick, Promise microtasks, timers, and I/O - with diagrams, code examples, and common pitfalls.' WHERE id='s_ndc_11';

-- ===== Section 1: Event Loop =====
UPDATE kg_nodes SET description_en=
'Node.js = V8 (the JS engine, same as Chrome)
       + libuv (event loop + thread pool + async I/O)
       + C++ bindings + core libraries written in JS.

At the JavaScript level, YOUR code runs on a SINGLE thread
(the main thread). But underneath, libuv has a thread pool
(4 threads by default) for blocking work such as file
reads, DNS, and heavy crypto.

Overall model:
  single-threaded event loop + non-blocking I/O

Example - threads:
  const os = require("os");
  console.log(os.cpus().length);  // e.g. 8 cores
  // but your JS still runs on 1 thread; to use every
  // core you need cluster / worker_threads

That is why Node is great for I/O-bound work (APIs,
network, DB) and needs special techniques for CPU-bound
work.' WHERE id='n_el_arch';

UPDATE kg_nodes SET description_en=
'The event loop runs forever through fixed phases; each
phase has its own callback queue:
  1. timers        - setTimeout / setInterval that are due
  2. pending cbs   - a few I/O callbacks deferred earlier
  3. idle/prepare  - internal
  4. poll          - receive & run I/O callbacks (sockets)
  5. check         - setImmediate
  6. close cbs     - e.g. socket.on("close")

Between every phase, Node drains all microtasks (nextTick
then Promise) before moving on.

Example - phase order:
  const fs = require("fs");
  fs.readFile(__filename, () => {   // callback runs in poll
    setImmediate(() => console.log("check"));
    setTimeout(() => console.log("timers"), 0);
  });
  // Prints: check -> timers
  // because check comes right after poll; timers waits
  // for the next round

See the node "How the event loop runs one tick in detail".' WHERE id='n_el_phases';

UPDATE kg_nodes SET description_en=
'Macrotask = a callback inside a phase (timers, I/O,
setImmediate, close). Microtask = 2 high-priority queues
that run BETWEEN macrotasks:
  • process.nextTick queue        (priority 1)
  • Promise / queueMicrotask queue (priority 2)

Rule: after each macrotask, drain ALL nextTick then ALL
Promise, then move to the next macrotask. So microtasks
always run before setTimeout even with timeout = 0.

Example:
  setTimeout(() => console.log("macro"), 0);
  Promise.resolve().then(() => console.log("micro"));
  process.nextTick(() => console.log("nextTick"));
  // Prints: nextTick -> micro -> macro

Pitfall: microtasks that spawn microtasks are all drained
in the same turn -> a very long microtask chain can delay
I/O.' WHERE id='n_el_micro_macro';

UPDATE kg_nodes SET description_en=
'Two ways to defer work, differing in timing:
  • process.nextTick(cb): runs RIGHT after the current
    operation, BEFORE the loop continues (a microtask,
    even higher priority than Promise).
  • setImmediate(cb): runs in the check phase, i.e. the
    NEXT turn, after the loop has passed through poll (I/O).

Example:
  setImmediate(() => console.log("immediate"));
  process.nextTick(() => console.log("nextTick"));
  // Prints: nextTick -> immediate

When to use:
  • Must run before everything (e.g. emit an error
    consistently)          -> nextTick
  • Must yield to I/O, safe looping -> setImmediate

Abusing recursive nextTick -> I/O starvation (see the
starvation node).' WHERE id='n_el_nexttick';

UPDATE kg_nodes SET description_en=
'setTimeout/setInterval are NOT exact: they run in the
timers phase and guarantee >= the requested delay, not the
exact ms (depends on event loop load). setTimeout(fn,0) is
effectively at least ~1ms.

Example - later than expected:
  const t = Date.now();
  setTimeout(() => {
    console.log(Date.now() - t);  // could be 5, 20... ms
  }, 0);
  for (let i = 0; i < 1e9; i++) {} // block loop -> late timer

Remember clearTimeout/clearInterval to avoid leaks and to
avoid keeping the process alive unintentionally.

Promise-based timer:
  import { setTimeout as sleep } from "timers/promises";
  await sleep(1000);' WHERE id='n_el_timers';

UPDATE kg_nodes SET description_en=
'Heavy CPU work on the JS thread BLOCKS every other request
(only one thread). Usual culprits: big loops, JSON.parse of
huge strings, sync crypto, catastrophic regex backtracking,
reading a whole large file into RAM.

BLOCKING example (bad):
  app.get("/hash", (req, res) => {
    const h = crypto.pbkdf2Sync(pw, salt, 1e6, 64, "sha512");
    res.send(h);   // every other request waits here
  });

How to avoid:
  • Use the async variant (pbkdf2 instead of pbkdf2Sync)
    -> thread pool
  • Move computation to Worker Threads
  • Split work with setImmediate
  • Use streams instead of reading whole files

Measure loop delay: perf_hooks.monitorEventLoopDelay().' WHERE id='n_el_blocking';

-- ===== Section 2: Modules =====
UPDATE kg_nodes SET description_en=
'CommonJS (CJS) loads modules SYNCHRONOUSLY; require()
returns module.exports. Note: exports is only an alias to
module.exports - reassigning the whole exports loses the
link.

Example:
  // math.js
  function add(a, b) { return a + b; }
  module.exports = { add };     // CORRECT
  // exports = { add };         // WRONG: link lost

  // app.js
  const { add } = require("./math");
  console.log(add(2, 3));       // 5

Circular dependency: require returns the PARTIAL exports at
the moment of the call -> may be undefined if used too
early.' WHERE id='n_mod_cjs';

UPDATE kg_nodes SET description_en=
'Node WRAPS every CJS file in a function before running it:
  (function (exports, require, module, __filename, __dirname) {
     // your code here
  });

Thanks to that: variables declared in the file are LOCAL
(they do not leak into global) and the 5 parameters above
are always available.

Example:
  console.log(__dirname);   // directory of the file
  console.log(__filename);  // full path of the file
  // at CJS module level: this === module.exports

This is why you do not need a manual IIFE to avoid leaking
variables into global, unlike a <script> tag in a browser.' WHERE id='n_mod_wrapper';

UPDATE kg_nodes SET description_en=
'require("x") searches in this order:
  1. Core module? ("fs","path"...) -> use it directly
  2. Starts with "./" or "../" -> relative file/folder
  3. Otherwise -> look in node_modules, walking UP the
     parent directories to the root
  4. Inside a package: read package.json (main / exports);
     if a folder, try index.js
  Extensions tried: .js -> .json -> .node

Example - /app/src/a.js calls require("lodash"):
  try /app/src/node_modules/lodash
      /app/node_modules/lodash     <- found here
      /node_modules/lodash

A loaded module is cached in require.cache by absolute path
-> a second require does NOT re-run the file.' WHERE id='n_mod_resolution';

UPDATE kg_nodes SET description_en=
'ES Modules (ESM) are enabled by the .mjs extension or
"type":"module" in package.json. import/export are STATIC,
load ASYNCHRONOUSLY, and support top-level await.

Example:
  // math.mjs
  export function add(a, b) { return a + b; }
  export default 42;

  // app.mjs
  import answer, { add } from "./math.mjs";
  const res = await fetch(url);   // top-level await OK

Differences from CJS:
  • No __dirname/__filename; instead:
      import { fileURLToPath } from "url";
      const __filename = fileURLToPath(import.meta.url);
  • import is a live binding (sees updated export values)
  • Static analysis -> enables tree-shaking
  • Always in strict mode' WHERE id='n_mod_esm';

UPDATE kg_nodes SET description_en=
'ESM and CJS work together but NOT symmetrically:
  • ESM importing CJS: OK. default = module.exports.
      import pkg from "cjs-lib";
      const { foo } = pkg;   // named may not be detectable
  • CJS requiring ESM: NOT directly (ESM is async). Use
    dynamic import:
      const esm = await import("./mod.mjs");

Dynamic import() returns a Promise, works in both CJS and
ESM, and allows lazy loading:
  if (cond) {
    const { heavy } = await import("./heavy.js");
  }

Note: ESM has no require/module/exports by default.' WHERE id='n_mod_interop';

-- ===== Section 3: Streams & Buffer =====
UPDATE kg_nodes SET description_en=
'Streams process data in CHUNKS -> no need to load a whole
file into RAM. 4 types:
  • Readable  - source: fs.createReadStream, req
  • Writable  - sink: res, fs.createWriteStream
  • Duplex    - two-way: TCP socket
  • Transform - a Duplex that transforms data: zlib.gzip,
    crypto

Example - copy a file without eating RAM even at 10GB:
  const fs = require("fs");
  fs.createReadStream("big.mp4")
    .pipe(fs.createWriteStream("copy.mp4"));

Versus reading all at once (eats RAM, may crash):
  const data = fs.readFileSync("big.mp4"); // loads all 10GB

Streams are the base of HTTP, files, compression, and
crypto in Node.' WHERE id='n_stream_types';

UPDATE kg_nodes SET description_en=
'Backpressure = the mechanism that throttles when the
WRITER is slower than the READER, so data does not pile up
without bound in memory.

Mechanism: write() returns false when the internal buffer
(highWaterMark) is full -> you should pause reading and
wait for the "drain" event before writing more. pipe() and
pipeline() handle this automatically.

Example - prefer pipeline (handles errors + closes resources):
  const { pipeline } = require("stream/promises");
  const fs = require("fs");
  const zlib = require("zlib");
  await pipeline(
    fs.createReadStream("in.txt"),
    zlib.createGzip(),
    fs.createWriteStream("in.txt.gz")
  );

Avoid chaining pipe() manually across many stages because
it leaks resources easily when an error occurs midway.' WHERE id='n_stream_backpressure';

UPDATE kg_nodes SET description_en=
'A Readable has 2 reading modes:
  • paused  - you actively call .read()
  • flowing - data flows automatically via the "data" event
Attaching a "data" listener or calling .pipe()/.resume()
switches to flowing; .pause() goes back to paused.

Example - flowing:
  rs.on("data", chunk => console.log(chunk.length));
  rs.on("end",  () => console.log("done"));

objectMode - lets a stream carry objects instead of only
Buffer/string:
  const { Readable } = require("stream");
  Readable.from([{ a: 1 }, { a: 2 }])
    .on("data", o => console.log(o.a));   // 1, 2' WHERE id='n_stream_modes';

UPDATE kg_nodes SET description_en=
'A Buffer is a fixed binary memory region OUTSIDE the V8
heap, representing a sequence of bytes. It is a subclass of
Uint8Array.

Creating a Buffer:
  Buffer.alloc(8);            // 8 bytes, zero-filled (safe)
  Buffer.allocUnsafe(8);      // faster, may contain garbage
  Buffer.from("hi", "utf8");  // from a string

Encoding conversions:
  const b = Buffer.from("Xin chao");
  b.toString("utf8");    // "Xin chao"
  b.toString("hex");     // e.g. "58696e..."
  b.toString("base64");

Used for files, network, and crypto - anywhere you work
with raw bytes instead of text.' WHERE id='n_buffer';

-- ===== Section 4: EventEmitter =====
UPDATE kg_nodes SET description_en=
'EventEmitter is the foundation of the event model in Node;
many core objects inherit from it (stream, http.Server,
process).

Example:
  const { EventEmitter } = require("events");
  const bus = new EventEmitter();
  bus.on("order", (id) => console.log("Handle order", id));
  bus.once("boot", () => console.log("runs once"));
  bus.emit("order", 101);  // emit is SYNC -> calls listeners now

Main API: on/addListener, once, emit, off/removeListener.

The "error" event is special: if you emit "error" with NO
listener -> Node throws and crashes:
  bus.on("error", err => console.error(err)); // always add one' WHERE id='n_ee_basic';

UPDATE kg_nodes SET description_en=
'emit is SYNCHRONOUS and calls listeners in sequence -> a
heavy listener blocks the thread.

Node warns when a single event has > 10 listeners
(MaxListenersExceededWarning) - usually a sign of a
forgotten listener removal:
  emitter.setMaxListeners(20);        // raise the limit if needed
  emitter.removeListener("data", fn); // remember to remove when done

Using with async:
  const { once, on } = require("events");
  await once(emitter, "ready");       // await an event as a Promise
  for await (const [msg] of on(emitter, "data")) { /* ... */ }

Leaked listeners are a common cause of memory leaks in
long-running apps (see the Memory leak node).' WHERE id='n_ee_leak';

-- ===== Section 5: Process / Cluster =====
UPDATE kg_nodes SET description_en=
'process is a global representing the current Node process.
Common properties/functions:
  process.argv            // command-line arguments
  process.env             // environment variables
  process.pid             // process id
  process.cwd()           // working directory
  process.memoryUsage()   // { rss, heapUsed, ... }
  process.hrtime.bigint() // high-resolution timing

Example - read arg + env - run: node app.js --port 4000
  const port = process.env.PORT || 3000;
  console.log(process.argv.slice(2)); // ["--port","4000"]

Lifecycle event:
  process.on("exit", code => console.log("exiting", code));' WHERE id='n_process_obj';

UPDATE kg_nodes SET description_en=
'Spawn a child process to run system commands or offload
heavy work. 4 main APIs:
  • spawn    - stream I/O, good for large output
  • exec     - runs via a shell, buffers all output
  • execFile - like exec but WITHOUT a shell (safer)
  • fork     - spawns a child Node process + an IPC channel

Example - spawn:
  const { spawn } = require("child_process");
  const ls = spawn("ls", ["-la"]);
  ls.stdout.on("data", d => console.log(String(d)));

Example - fork (two-way messaging):
  const child = fork("worker.js");
  child.send({ job: 1 });
  child.on("message", m => console.log("result", m));

Prefer execFile/spawn (no shell) to avoid shell injection
when user input is involved.' WHERE id='n_child_process';

UPDATE kg_nodes SET description_en=
'cluster forks the Node process (workers) to use MULTIPLE
CPU cores; the master distributes connections on the SAME
port.

Example:
  const cluster = require("cluster");
  const os = require("os");
  if (cluster.isPrimary) {
    for (let i = 0; i < os.cpus().length; i++) cluster.fork();
  } else {
    require("./server.js");   // each worker runs the server
  }

Notes:
  • Each worker is a SEPARATE process with ISOLATED memory
    -> shared state (session, cache) must live outside
    (e.g. Redis).
  • In practice people use PM2: pm2 start app.js -i max
    (a convenient wrapper around cluster).

Versus worker_threads: cluster fits scaling I/O/HTTP.' WHERE id='n_cluster';

UPDATE kg_nodes SET description_en=
'Graceful shutdown = shutting the server down cleanly when
receiving a stop signal (SIGTERM on Docker/K8s rolling
update, SIGINT on Ctrl+C) so in-flight requests are not cut
off.

Example:
  const server = app.listen(3000);
  function shutdown() {
    server.close(() => {   // stop accepting new connections
      db.end();            // close DB
      process.exit(0);
    });
    setTimeout(() => process.exit(1), 10000); // force exit if stuck
  }
  process.on("SIGTERM", shutdown);
  process.on("SIGINT", shutdown);

Without this step, a deploy abruptly cuts in-flight
requests and causes errors for users.' WHERE id='n_signals';

-- ===== Section 6: Worker Threads =====
UPDATE kg_nodes SET description_en=
'worker_threads run JS in PARALLEL across multiple threads
within the SAME process -> for CPU-bound work (crypto,
image processing, computation) without blocking the main
thread.

Example:
  // main.js
  const { Worker } = require("worker_threads");
  const w = new Worker("./calc.js", { workerData: 40 });
  w.on("message", r => console.log("fib =", r));

  // calc.js
  const { parentPort, workerData } = require("worker_threads");
  function fib(n) { return n < 2 ? n : fib(n-1) + fib(n-2); }
  parentPort.postMessage(fib(workerData));

Each worker has its own V8 + event loop. They communicate
via postMessage (structured clone) or SharedArrayBuffer.
Unlike cluster: workers can share memory and are lighter
than processes.' WHERE id='n_worker_threads';

UPDATE kg_nodes SET description_en=
'By default data sent between workers is COPIED (structured
clone). SharedArrayBuffer lets multiple workers read/write
ONE memory region without copying -> high performance.

Atomics guarantee atomic + synchronized operations to avoid
race conditions:
  const sab = new SharedArrayBuffer(4);
  const arr = new Int32Array(sab);
  Atomics.add(arr, 0, 5);   // atomic add
  Atomics.load(arr, 0);     // safe read
  // Atomics.wait / notify: synchronize between threads

Pass sab to a worker via workerData/postMessage; every
thread sees the same data. Used for counters, queues, and
numeric data shared across threads.' WHERE id='n_shared_mem';

UPDATE kg_nodes SET description_en=
'Three ways to offload work, chosen by the problem:

  worker_threads - multiple THREADS in one process, SHARED
    memory, lightweight.  -> CPU-bound work (computation,
    crypto, image processing).

  cluster - multiple PROCESSES listening on one port,
    isolated memory.  -> scaling HTTP/I/O across cores
    (usually via PM2).

  child_process - runs a separate program, fully isolated.
    -> running system commands or external scripts.

Quick rule:
  • Heavy computation          -> worker_threads
  • Many requests per core      -> cluster (or PM2)
  • Call external tool/command  -> child_process' WHERE id='n_worker_vs_cluster';

-- ===== Section 7: Core Modules =====
UPDATE kg_nodes SET description_en=
'The fs module has 3 API styles:
  • Sync:     fs.readFileSync (BLOCKS the loop; use only at
    startup or in small scripts)
  • Callback: fs.readFile(path, cb) (err-first)
  • Promise:  fs.promises (prefer with async/await)

Example:
  const fs = require("fs/promises");
  const data = await fs.readFile("config.json", "utf8");
  await fs.writeFile("out.txt", "hello");

Large files -> use streams instead of reading the whole file:
  const fss = require("fs");
  fss.createReadStream("big.log").pipe(process.stdout);

fs operations run on the libuv THREAD POOL (limited by
UV_THREADPOOL_SIZE). fs.watch watches file changes.' WHERE id='n_fs';

UPDATE kg_nodes SET description_en=
'The http module creates HTTP servers and clients. req is a
Readable stream, res is a Writable stream.

Server:
  const http = require("http");
  http.createServer((req, res) => {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ ok: true }));
  }).listen(3000);

Client:
  http.get("http://api.local/ping", res => {
    let body = "";
    res.on("data", c => body += c);
    res.on("end", () => console.log(body));
  });

Express/Fastify build on http. net is the lower TCP layer;
http2 supports multiplexing. Agent manages the connection
pool (keep-alive) for reuse, reducing TCP handshake cost.' WHERE id='n_http';

UPDATE kg_nodes SET description_en=
'crypto provides standard cryptographic/hash functions - do
NOT roll your own algorithm.

Hashing and random values:
  const crypto = require("crypto");
  crypto.createHash("sha256").update("abc").digest("hex");
  crypto.randomUUID();                  // random id
  crypto.randomBytes(16).toString("hex");

Password hashing - use the ASYNC variant since it is heavy
(runs on the thread pool):
  crypto.scrypt(pw, salt, 64, (err, key) => { /* ... */ });
  // AVOID scryptSync in a request -> blocks the loop

Also: HMAC, symmetric encryption (createCipheriv),
asymmetric sign/verify. Use randomBytes/randomUUID for
tokens; do NOT use Math.random (not cryptographically safe).' WHERE id='n_crypto';

UPDATE kg_nodes SET description_en=
'A group of cross-platform utility modules.

path - handles paths correctly on both Windows and Linux:
  const path = require("path");
  path.join("a", "b", "c.txt");   // "a/b/c.txt"
  path.resolve("src", "app.js");  // absolute path
  path.extname("a.png");          // ".png"
  path.basename("/x/y.txt");      // "y.txt"

os - system information:
  const os = require("os");
  os.cpus().length;   // number of cores
  os.totalmem();      // total RAM
  os.platform();      // "linux" | "win32" | "darwin"

URL / URLSearchParams to parse & build URLs. Always use
path.join instead of concatenating "/" by hand.' WHERE id='n_path_os';

UPDATE kg_nodes SET description_en=
'util and a few utility modules used often when modernizing
code.

util.promisify - turns a callback (err-first) function into
a Promise:
  const util = require("util");
  const fs = require("fs");
  const readFile = util.promisify(fs.readFile);
  const data = await readFile("a.txt", "utf8");

util.inspect - deep, colored object logging:
  console.log(util.inspect(obj, { depth: null, colors: true }));

zlib - compress/decompress (it is a Transform stream):
  const zlib = require("zlib");
  readable.pipe(zlib.createGzip()).pipe(writable);

timers/promises - Promise-based setTimeout:
  import { setTimeout as sleep } from "timers/promises";
  await sleep(500);' WHERE id='n_util';

-- ===== Section 8: Error Handling =====
UPDATE kg_nodes SET description_en=
'Classify errors to decide whether to HANDLE or CRASH:

  • Operational error - an expected runtime failure: DB
    connection lost, timeout, bad input, out of disk.
    -> catch, log, retry or return an error to the client.
  • Programmer error - a BUG in code: calling a function on
    undefined, forgetting await, wrong type.
    -> let the process CRASH and restart cleanly (fail
       fast), because the state is no longer trustworthy.

Example:
  // operational: handle it
  try { await db.query(sql); }
  catch (e) { logger.warn(e); return res.status(503).end(); }

  // programmer: do not swallow, fix the bug
  user.nmae;  // typo -> undefined, a silent logic error

Swallowing every error hides bugs and lets the app run in a
broken state.' WHERE id='n_err_types';

UPDATE kg_nodes SET description_en=
'How to catch errors depends on the async style:

  • async/await -> try/catch:
      try { const u = await getUser(id); }
      catch (e) { handle(e); }

  • Promise -> .catch():
      getUser(id).then(use).catch(handle);

  • Err-first callback -> check the first argument:
      fs.readFile(p, (err, data) => {
        if (err) return handle(err);
      });

Common pitfall: FORGETTING await -> the error becomes an
unhandledRejection:
  async function f() { doAsync(); }  // missing await/return

Express 4: an async handler must next(err) or use a wrapper;
Express 5 catches rejected Promises automatically.
In parallel: Promise.all (fail-fast) vs Promise.allSettled
(returns all results including errors).' WHERE id='n_err_async';

UPDATE kg_nodes SET description_en=
'Two final safety nets for uncaught errors:

  process.on("uncaughtException", err => {
    logger.fatal(err);
    process.exit(1);   // SHOULD exit: state is not trustworthy
  });
  process.on("unhandledRejection", reason => {
    logger.error(reason);
    process.exit(1);
  });

• uncaughtException: a sync error not caught by try/catch.
• unhandledRejection: a rejected Promise with no .catch
  (since Node 15 this crashes the process by default).

Philosophy: do not use these to carry on as if nothing
happened. Log, then let the process manager (PM2 /
Kubernetes) restart the process cleanly - safer than trying
to recover.' WHERE id='n_err_global';

UPDATE kg_nodes SET description_en=
'AsyncLocalStorage keeps context across an async chain
WITHOUT passing arguments manually through every function -
like thread-local storage. Built on async_hooks.

Example - attach a correlation id per request for logging:
  const { AsyncLocalStorage } = require("async_hooks");
  const als = new AsyncLocalStorage();

  app.use((req, res, next) => {
    als.run({ reqId: crypto.randomUUID() }, () => next());
  });

  function log(msg) {
    const store = als.getStore();
    console.log(`[${store?.reqId}] ${msg}`);
  }
  // every deep awaited function still sees the right reqId

Used for correlated logging, tracing, and multi-tenant.
There is a small performance cost but it is usually
acceptable.' WHERE id='n_als';

-- ===== Section 9: V8 & Memory =====
UPDATE kg_nodes SET description_en=
'V8 is the JS engine of Node (the same engine as Chrome).
Compilation pipeline:
  JS source -> parse (AST) -> bytecode (Ignition)
            -> optimized machine code (TurboFan) for HOT code
            -> may de-optimize when types change unexpectedly

Tips to help V8 optimize (keep hidden classes stable):
  // GOOD: consistent object shape
  function P(x, y) { this.x = x; this.y = y; }
  const p = new P(1, 2);
  // BAD: adding a field later -> changes shape -> slower
  p.z = 3;

Practical takeaway: initialize objects with the same field
order, avoid changing a variable type, avoid deleting
properties in a hot loop. Tuning flag: node --v8-options.' WHERE id='n_v8';

UPDATE kg_nodes SET description_en=
'V8 collects garbage (GC) GENERATIONALLY because most
objects die young:
  • Young generation - new objects; collected by the
    Scavenger, fast, runs often.
  • Old generation   - long-lived objects; collected by
    Mark-Sweep-Compact, slower.
GC causes a short stop-the-world pause.

The heap has a default LIMIT (~a few GB depending on
version), tune it:
  node --max-old-space-size=4096 app.js   // 4GB

Manual example (only when run with --expose-gc, for tests):
  if (global.gc) global.gc();

An object that is still referenced is NOT collected ->
holding a reference unintentionally is exactly a memory
leak (see the next node).' WHERE id='n_gc';

UPDATE kg_nodes SET description_en=
'Memory leak in a long-running app: the heap grows steadily
then OOM. Common causes:
  • accumulating variables/globals (unbounded cache)
  • EventEmitter listeners never removed
  • closures holding large references
  • timers (setInterval) never cleared

A classic leak example:
  const cache = {};
  app.get("/u/:id", (req, res) => {
    cache[req.params.id] = bigObject;  // never deleted
  });                                   // -> grows forever

Detection:
  console.log(process.memoryUsage().heapUsed); // watch it grow
  // heap snapshot: node --inspect + Chrome DevTools
  // or the flag --heapsnapshot-near-heap-limit

Cache fix: use a bounded LRU cache.' WHERE id='n_memory';

UPDATE kg_nodes SET description_en=
'Measure BEFORE optimizing - do not guess. Built-in tools:

perf_hooks - measure time & event loop delay:
  const { performance, monitorEventLoopDelay } =
    require("perf_hooks");
  const t = performance.now();
  doWork();
  console.log(performance.now() - t, "ms");

  const h = monitorEventLoopDelay(); h.enable();
  // after a while: h.mean, h.max -> loop delay (ns)

CPU profiling:
  node --prof app.js     // produces an isolate log to analyze
  node --inspect app.js  // attach Chrome DevTools
  // or clinic.js, 0x (flamegraph)

Process: measure -> find the real hot spot -> optimize the
right place -> measure again to confirm.' WHERE id='n_perf';

-- ===== Section 10: Event Loop & libuv (deep dive) =====
UPDATE kg_nodes SET description_en=
'libuv is a cross-platform C library that provides the
EVENT LOOP and async I/O for Node.js. Its core role: hide
the differences of each operating system I/O mechanism
behind ONE common API - it wraps epoll (Linux), kqueue
(macOS/BSD), IOCP (Windows).

DIAGRAM - when you call an async API:

  Your JS code (runs on V8, 1 thread)
    │  e.g. fs.readFile(), db.query(), crypto.pbkdf2()
    ▼
  Node.js C++ bindings
    │
    ▼
  libuv  ── splits work into 2 directions:
    │
    ├─► EVENT LOOP (main thread)
    │     • used for NETWORK I/O (TCP/UDP/pipe)
    │     • via epoll / kqueue / IOCP
    │     • 1 thread watches thousands of sockets
    │
    └─► THREAD POOL (4 threads by default)
          • for work with NO async at the kernel:
            fs.* (file), dns.lookup,
            heavy crypto (pbkdf2/scrypt), zlib
          • runs blocking on a helper thread,
            then returns the result to the event loop

KEY POINT (often misunderstood):
• Network I/O does NOT use the thread pool. libuv uses
  non-blocking sockets + kernel epoll directly, with just
  ONE thread.
• Only file I/O, DNS lookup, heavy crypto, and zlib are
  pushed to the thread pool - because on most OSes they
  have no true async API at the kernel level.

Set the pool size with the UV_THREADPOOL_SIZE env var (set
it BEFORE Node starts, max 1024).' WHERE id='n_dd_libuv';

UPDATE kg_nodes SET description_en=
'The event loop is an infinite loop that libuv runs on the
main thread. Each iteration is a TICK, going through phases
in a FIXED order; each phase has its own callback queue
(FIFO).

DIAGRAM of one tick:

  ┌─► (1) timers        → setTimeout/setInterval cbs due
  │   (2) pending cbs   → a few I/O callbacks deferred earlier
  │   (3) idle/prepare  → internal to libuv
  │   (4) poll   ★★★    → get I/O events from the kernel,
  │                       run I/O callbacks (read sockets...)
  │   (5) check         → setImmediate callbacks
  │   (6) close cbs     → e.g. socket.on("close")
  │        │
  └────────┘  after phase 6, back to phase 1 (new tick)

  ⚡ After EACH callback and between EACH phase, Node drains
     microtasks:
       1. nextTick queue   → drain until EMPTY
       2. Promise queue    → drain until EMPTY
     then runs the next callback / phase.

Meaning of each phase:
• timers: check the clock, run timers that are due.
• pending callbacks: some deferred system I/O errors/
  completions (e.g. TCP ECONNREFUSED).
• poll: the heart of the loop - runs ready I/O callbacks
  and decides whether to sleep waiting for I/O.
• check: where setImmediate runs, right after poll.
• close: cleanup, emit close events.

The loop ENDS when there is no active handle/request left
(no timer, socket, or pending callback) - then the Node
process exits.' WHERE id='n_dd_eventloop_detail';

UPDATE kg_nodes SET description_en=
'A common confusion: thinking there is only one callback
queue. In reality the event loop is NOT a queue, it is a
SCHEDULER; and there are MANY queues.

DIAGRAM:

  EVENT LOOP = the scheduler
  │  it visits each phase in turn; each phase has 1 queue:
  │
  ├─ timers queue      [ cb, cb, ... ]   (macrotask)
  ├─ pending queue     [ ... ]           (macrotask)
  ├─ poll / IO queue   [ ... ]           (macrotask)
  ├─ check queue       [ setImmediate ]  (macrotask)
  └─ close queue       [ ... ]           (macrotask)

  OUTSIDE the phases there are 2 high-priority MICROTASK
  queues:
  ├─ nextTick queue    → drained FIRST  (priority 1)
  └─ Promise queue     → drained SECOND (priority 2)

HOW IT FITS TOGETHER:
  pick a phase → run its whole queue
    → drain the entire nextTick queue
    → drain the entire Promise queue
    → move to the next phase

In short:
• Event loop = the coordinator deciding what runs and when.
• Queue = where callbacks line up and wait.
What simple diagrams call one callback queue is really MANY
queues split by phase, plus 2 separate microtask queues.' WHERE id='n_dd_loop_vs_queue';

UPDATE kg_nodes SET description_en=
'Poll is the most important phase. It does two things:
(1) run callbacks for completed I/O events; (2) decide
whether the event loop SLEEPS (blocks) and for how long.

DECISION TREE on entering POLL:

  Enter POLL phase
  │
  ├─ Does the poll queue HAVE callbacks?
  │     └─ YES → run them all (up to a system limit)
  │             then move on to the check phase
  │
  └─ Is the poll queue EMPTY?
        ├─ Is there a setImmediate waiting?
        │     └─ DO NOT sleep → jump to CHECK phase now
        │
        ├─ Is there a timer about to be due?
        │     └─ sleep AT MOST until the nearest timer,
        │        then go back to the TIMERS phase
        │
        └─ Nothing at all?
              └─ sleep waiting for I/O (epoll_wait) until
                 the kernel reports an event

MEANING:
• This is why Node sleeps when idle instead of spinning and
  burning CPU (busy-wait) - energy and CPU efficient.
• It also explains why the order of setTimeout(0) vs
  setImmediate is NOT deterministic at top-level (depends
  on whether the loop crosses the ~1ms timer threshold in
  time).' WHERE id='n_dd_poll';

UPDATE kg_nodes SET description_en=
'The libuv thread pool has 4 threads by default (set via
UV_THREADPOOL_SIZE before Node starts, max 1024). It serves
blocking tasks that have no async at the kernel.

DIAGRAM:

  EVENT LOOP ──hand off work──► THREAD POOL (4 threads default)
                             ├─ thread #1  [busy: read file A]
                             ├─ thread #2  [busy: pbkdf2]
                             ├─ thread #3  [idle]
                             └─ thread #4  [idle]
                                   │
                       done work ──┘
                             │
  EVENT LOOP ◄──push result back──┘  (callback into the right phase)

WHAT USES THE THREAD POOL:
• fs.*  - file read/write (file I/O is not truly
  non-blocking on most OSes).
• dns.lookup (getaddrinfo). Note: dns.resolve uses the
  network, so it does NOT go through the pool.
• heavy crypto: pbkdf2, scrypt, randomBytes (async
  variant), part of TLS.
• zlib - compression/decompression.

REAL-WORLD PITFALL (often missed):
The pool has only 4 threads. If 5 heavy tasks (e.g. 5
pbkdf2 calls) run at once, the 5th waits for a free thread
→ a confusing latency even though the CPU is free. Fix:
raise UV_THREADPOOL_SIZE sensibly (usually near the number
of CPU cores), or move heavy computation to Worker Threads.' WHERE id='n_dd_threadpool';

UPDATE kg_nodes SET description_en=
'Node achieves high I/O performance by leveraging the async
I/O mechanism of the kernel. There are TWO models:

MODEL 1 - READINESS (Linux epoll, macOS/BSD kqueue):
  App: "tell me when this socket is READABLE"
    │  → register the fd into epoll
    ▼
  Kernel: (when data arrives) "the fd is READY"
    │
    ▼
  App: calls read() non-blocking to get the data

MODEL 2 - COMPLETION (Windows IOCP):
  App: "read this socket for me"  → submit a request
    │
    ▼
  Kernel: reads it itself  → "DONE, here is the data"

libuv abstracts both behind one API.

WHY IT MATTERS - comparing serving models:

  Old style (traditional Apache/PHP):
    1 connection = 1 thread (or process)
    10,000 connections → 10,000 threads
    → heavy RAM, heavy context-switching, hard to scale

  Node style (epoll):
    1 thread uses epoll to watch ALL fds
    10,000 connections → 1 thread + 1 list of fds
    → very light (this is the C10K problem)

For the network, libuv uses epoll/kqueue/IOCP directly (1
thread). For files, due to OS limits, libuv SIMULATES async
using the thread pool.' WHERE id='n_dd_nonblocking_os';

UPDATE kg_nodes SET description_en=
'Node is single-threaded in that YOUR JS code runs on ONE
thread (the main thread) - there are never two pieces of JS
running in parallel, so ordinary variables need no
lock/mutex. Yet it is still CONCURRENT by offloading I/O to
the kernel/thread pool.

TWO CONCEPTS (with a diagram):

  CONCURRENCY - interleaving on 1 thread (Node is great at this):
    req A ──call DB──▶ (waiting for DB...)
    req B ─────────▶ handled while A waits
    req A ◀─DB done─ continues its rest
    → 1 thread, no one sits idle

  PARALLELISM - truly simultaneous (needs Worker/cluster):
    core 1: ████ task 1
    core 2: ████ task 2   ← at the same moment

CONSEQUENCE:
• Node is very strong for I/O-BOUND load (APIs calling
  DB/network/file): while waiting for I/O the JS thread
  does other work.
• For CPU-BOUND load (heavy computation, big loops, sync
  crypto): the JS thread is BLOCKED and all other requests
  wait → move it to Worker Threads or cluster for real
  parallelism.' WHERE id='n_dd_singlethread';

-- ===== Section 11: Request lifecycle & Execution order =====
UPDATE kg_nodes SET description_en=
'A full trace of a GET request into an http/Express server,
from the TCP packet to the client receiving the response.

TIMELINE DIAGRAM:

  CLIENT
    │ (1) send an HTTP request (TCP packet)
    ▼
  KERNEL ── marks the socket readable ──► epoll notifies libuv
    │
    ▼
  (2) POLL phase: libuv reads bytes,
      llhttp parses HTTP
      → creates req (IncomingMessage = Readable stream)
      → creates res (ServerResponse = Writable stream)
    │
    ▼
  (3) V8 runs your JS handler (sync, 1 thread)
    │  e.g. app.get("/x", async (req,res) => { ... })
    ▼
  (4) the handler calls I/O:  await db.query(...)
    │  → the query goes out via the DB socket, handler RETURNS NOW
    │  → the main thread is FREE, serves other requests
    ⋮   ... the event loop keeps spinning other rounds ...
    ▼
  (5) DB returns a result → the DB socket is readable
    │  → the POLL phase runs the callback
    │  → the Promise resolves → code after await goes into
    │    the microtask queue → finishes
    ▼
  (6) res.json(...) / res.end()
    │  → writes data to the socket (non-blocking)
    │  → if the buffer is full: wait for "drain" (backpressure)
    ▼
  KERNEL sends the TCP packet back to the CLIENT
    │
    ▼
  (7) keep-alive (reuse the socket)
      or close (runs in the close-callbacks phase)

KEY POINT: steps (4)-(5) are why ONE thread can serve
thousands of interleaved requests - while this request
waits for I/O, the thread handles other requests instead of
sitting idle.' WHERE id='n_dd_request_lifecycle';

UPDATE kg_nodes SET description_en=
'Golden rule: after EACH callback and between each phase,
Node drains ALL of the nextTick queue → then ALL of the
Promise microtask queue → then runs the next macrotask.

CLASSIC EXAMPLE:
  console.log("1");
  setTimeout(() => console.log("2 timeout"), 0);
  setImmediate(() => console.log("3 immediate"));
  Promise.resolve().then(() => console.log("4 promise"));
  process.nextTick(() => console.log("5 nextTick"));
  console.log("6");

STEP-BY-STEP TRACE:

  ◆ Synchronous phase (runs in order right away):
      print "1"
      register timeout   → timers queue:  [2]
      register immediate → check queue:   [3]
      register .then     → Promise queue: [4]
      register nextTick  → nextTick queue:[5]
      print "6"

  ◆ End of sync → drain microtasks:
      nextTick queue first → print "5"
      Promise queue next   → print "4"

  ◆ Enter the event loop (phases):
      timers phase → print "2"
      check  phase → print "3"

  ➜ RESULT:  1  6  5  4  2  3

NOTES:
• Synchronous code always finishes first (1, 6).
• nextTick (5) always before Promise (4); both always
  before timer/immediate.
• At top-level, the order of 2 (timeout) vs 3 (immediate)
  is NOT guaranteed; but inside an I/O callback, 3
  (immediate) always comes first.' WHERE id='n_dd_exec_order';

UPDATE kg_nodes SET description_en=
'The result depends on WHERE you call them in the event
loop cycle.

POSITION WITHIN ONE LOOP:

  ... → poll ──▶ check ──▶ (new round) timers → ...
                  ▲                      ▲
           setImmediate            setTimeout(0)

  → Standing at poll (where I/O callbacks run), the NEXT
    phase is check. So INSIDE an I/O callback: setImmediate
    always runs BEFORE setTimeout(0), while timers must wait
    for the next round.

CASE 1 - inside an I/O callback (DETERMINISTIC):
  const fs = require("fs");
  fs.readFile(__filename, () => {
    setTimeout(() => console.log("timeout"), 0);
    setImmediate(() => console.log("immediate"));
  });
  // ALWAYS prints:  immediate  →  timeout

CASE 2 - at top-level (NOT deterministic):
  setTimeout(() => console.log("timeout"), 0);
  setImmediate(() => console.log("immediate"));
  // The order may change each run, because setTimeout(0)
  // effectively has a ~1ms minimum threshold; depends on
  // whether the loop crosses that threshold in time.

PRACTICAL TAKEAWAY:
To run right after the current I/O finishes, use
setImmediate - it has a deterministic position in the
cycle; setTimeout(0) does not.' WHERE id='n_dd_timeout_immediate';

UPDATE kg_nodes SET description_en=
'async/await is just syntax over Promises. Understanding
what it compiles to explains the exact ordering.

WHEN await IS HIT:
• The async function PAUSES at the await point and returns
  a Promise to the caller RIGHT AWAY (does not block the
  thread).
• All code AFTER await is registered as a MICROTASK, run
  only when the awaited Promise resolves.

ILLUSTRATION - the two snippets are equivalent:

  // Written with async/await:
  async function f() {
    console.log("A");
    await something;        // ◄ CUT POINT
    console.log("B");       // ◄ this part becomes a microtask
  }

  // Equivalent (simplified):
  function f() {
    console.log("A");
    return Promise.resolve(something).then(() => {
      console.log("B");
    });
  }

  → "A" runs SYNCHRONOUSLY; "B" is DEFERRED into the
    microtask queue - even if something is already ready
    (await 5 still defers "B").

CONSEQUENCES:
• await always yields to the event loop for at least one
  microtask turn.
• An async/await chain is really a series of chained
  microtasks → they ALWAYS run before setTimeout/
  setImmediate of the same turn.
• Modern V8 is optimized so awaiting a native Promise does
  not create a redundant intermediate Promise.' WHERE id='n_dd_async_await_compile';

UPDATE kg_nodes SET description_en=
'When a Promise settles, the registered .then/.catch/
.finally callbacks do NOT run immediately - they are pushed
into the MICROTASK QUEUE (V8 PromiseJobs).

LIFECYCLE DIAGRAM:

  Promise (pending)
    │  resolve(value)
    ▼
  Promise (fulfilled)
    │  pushes the .then callbacks into the MICROTASK QUEUE
    │  (does not run them right there)
    ▼
  Event loop: after each macrotask/phase → drain microtasks
    │  if a callback creates a new microtask
    │  → it is drained in the SAME turn
    ▼
  ... repeat until the queue is EMPTY, then move to another phase

THE TWO MICROTASK QUEUES OF NODE (drain order):
  ├─ nextTick queue   → drained FIRST (Node-specific, not in
  │                      the JS standard)
  └─ Promise queue    → drained SECOND

TOOLS & NOTES:
• queueMicrotask(fn) lets you push a function into the
  Promise microtask queue directly.
• Since microtasks are drained until EMPTY, a very long (or
  infinitely self-spawning) microtask chain can delay I/O
  and timers - see the "starvation" node.' WHERE id='n_dd_promise_microtask';

UPDATE kg_nodes SET description_en=
'Because Node drains the ENTIRE nextTick queue (then the
Promise queue) before letting the event loop continue, a
callback that keeps rescheduling itself with nextTick (or
recursive microtasks) will make the loop NEVER reach the
poll phase → I/O and timers are starved, and the app seems
to hang even though the CPU is not busy.

COMPARISON DIAGRAM:

  ✗ WRONG - stuck event loop (starvation):
      function loop() { process.nextTick(loop); }
      loop();

      the nextTick queue is NEVER empty
        → microtasks drain forever
        → the loop never reaches the poll phase
        → all I/O / timers are starved → the app hangs

  ✓ RIGHT - yield to I/O:
      function loop() { setImmediate(loop); }
      loop();

      setImmediate runs in the check phase
        → between iterations, the loop STILL visits poll
        → I/O and timers still get served

CONCLUSION:
This is the most important practical difference between
process.nextTick and setImmediate:
• nextTick = cut in immediately, easy to starve I/O if
  abused/recursive.
• setImmediate = wait for the turn after poll, safe for a
  loop that needs to yield to I/O.' WHERE id='n_dd_starvation';


-- ===== TOPIC: PostgreSQL Core (xem seed_postgres.sql) =====
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
-- Topic
('t_pg','PostgreSQL Core','Database',
'Kiến thức chuyên sâu về PostgreSQL: kiến trúc tiến trình, MVCC, WAL, index và query planner, transaction/isolation, cùng các tính năng nâng cao (JSONB, CTE, window, partition). Dùng để hiểu bản chất khi tối ưu và phỏng vấn.',
'In-depth PostgreSQL: process architecture, MVCC, WAL, indexes and the query planner, transactions/isolation, plus advanced features (JSONB, CTE, window, partitioning). For deep understanding when tuning and in interviews.',
'[]',150,300),

-- Sections
('s_pg_1','Kiến trúc & MVCC','Database',
'Cách PostgreSQL tổ chức tiến trình/bộ nhớ và mô hình đa phiên bản (MVCC), WAL, VACUUM.',
'How PostgreSQL organizes processes/memory and its multi-version model (MVCC), WAL, and VACUUM.',
'[]',60,180),
('s_pg_2','Index & Query Planner','Database',
'Các loại index, cách planner chọn kế hoạch, và cách đọc EXPLAIN.',
'Index types, how the planner chooses a plan, and how to read EXPLAIN.',
'[]',260,180),
('s_pg_3','Transaction & Isolation','Database',
'Các mức cô lập, khóa (lock), deadlock và cách giao dịch hoạt động.',
'Isolation levels, locking, deadlocks, and how transactions work.',
'[]',60,440),
('s_pg_4','Tính năng nâng cao','Database',
'JSONB, CTE & window function, kiểu dữ liệu phong phú và partitioning.',
'JSONB, CTE & window functions, rich data types, and partitioning.',
'[]',260,440),

-- ===== Section 1: Kiến trúc & MVCC =====
('n_pg_arch','Kiến trúc tiến trình & bộ nhớ','Database',
'PostgreSQL theo mô hình ĐA TIẾN TRÌNH (mỗi kết nối = 1 process), khác
MySQL (đa luồng).

SƠ ĐỒ:

  Client ──┐
  Client ──┼─► postmaster (tiến trình cha, lắng nghe cổng 5432)
  Client ──┘        │  fork mỗi kết nối
                    ▼
              backend process (1 cho mỗi client)
                    │  đọc/ghi qua
                    ▼
  ┌─ Shared memory ───────────────────────────┐
  │  shared_buffers  (cache trang dữ liệu)     │
  │  WAL buffers                               │
  └────────────────────────────────────────────┘
                    │
                    ▼
     Data files trên đĩa + WAL + background workers
     (autovacuum, checkpointer, WAL writer)

Vì mỗi kết nối là 1 process khá nặng -> nên dùng connection
pooler (PgBouncer) thay vì mở hàng nghìn kết nối trực tiếp.',
'PostgreSQL uses a MULTI-PROCESS model (each connection = 1 process),
unlike MySQL (multi-threaded).

DIAGRAM:

  Client ──┐
  Client ──┼─► postmaster (parent process, listens on port 5432)
  Client ──┘        │  forks per connection
                    ▼
              backend process (one per client)
                    │  reads/writes via
                    ▼
  ┌─ Shared memory ───────────────────────────┐
  │  shared_buffers  (data page cache)         │
  │  WAL buffers                               │
  └────────────────────────────────────────────┘
                    │
                    ▼
     Data files on disk + WAL + background workers
     (autovacuum, checkpointer, WAL writer)

Because each connection is a fairly heavy process, use a
connection pooler (PgBouncer) instead of opening thousands of
direct connections.',
'[]',20,120),

('n_pg_mvcc','MVCC — đa phiên bản','Database',
'MVCC (Multi-Version Concurrency Control): mỗi UPDATE/DELETE KHÔNG
ghi đè tại chỗ mà tạo phiên bản mới của hàng (tuple). Người đọc
không chặn người ghi và ngược lại.

Mỗi tuple có 2 cột hệ thống ẩn:
  xmin = id transaction đã TẠO tuple
  xmax = id transaction đã XÓA/thay thế tuple

Ví dụ UPDATE:
  hàng cũ: (xmin=100, xmax=205)   <- bị đánh dấu chết
  hàng mới:(xmin=205, xmax=0)     <- phiên bản hiện hành

Mỗi transaction thấy snapshot theo id của mình -> đọc nhất
quán mà không cần khóa đọc.

HỆ QUẢ: tuple chết (dead tuple) tích tụ -> cần VACUUM dọn dẹp,
nếu không sẽ phình bảng (table bloat).',
'MVCC (Multi-Version Concurrency Control): an UPDATE/DELETE does
NOT overwrite in place; it creates a new version of the row
(tuple). Readers do not block writers and vice versa.

Every tuple has 2 hidden system columns:
  xmin = id of the transaction that CREATED the tuple
  xmax = id of the transaction that DELETED/replaced it

Example UPDATE:
  old row: (xmin=100, xmax=205)   <- marked dead
  new row: (xmin=205, xmax=0)     <- current version

Each transaction sees a snapshot based on its own id -> a
consistent read without read locks.

CONSEQUENCE: dead tuples accumulate -> VACUUM is needed to
clean them, otherwise the table bloats.',
'[]',140,120),

('n_pg_wal','WAL & Durability','Database',
'WAL (Write-Ahead Log): mọi thay đổi được ghi vào log TUẦN TỰ
TRƯỚC khi ghi vào data file. Đây là nền của độ bền (durability)
và khả năng phục hồi sau sự cố.

Luồng ghi:
  1. Sửa trang trong shared_buffers (trong RAM)
  2. Ghi bản ghi WAL + fsync khi COMMIT  <- điểm bền vững
  3. Trang "bẩn" được flush xuống đĩa sau (checkpoint)

Nhờ đó: nếu mất điện, khởi động lại sẽ replay WAL để khôi phục.
WAL cũng là nguồn cho replication (streaming) và PITR
(point-in-time recovery).

fsync=off nhanh hơn nhưng MẤT AN TOÀN — đừng dùng ở production.',
'WAL (Write-Ahead Log): every change is written SEQUENTIALLY to
the log BEFORE being written to the data files. This is the
basis of durability and crash recovery.

Write flow:
  1. Modify the page in shared_buffers (in RAM)
  2. Write the WAL record + fsync on COMMIT  <- durability point
  3. Dirty pages are flushed to disk later (checkpoint)

So if power is lost, on restart PostgreSQL replays the WAL to
recover. WAL also feeds replication (streaming) and PITR
(point-in-time recovery).

fsync=off is faster but UNSAFE - do not use it in production.',
'[]',20,180),

('n_pg_vacuum','VACUUM & Bloat','Database',
'Vì MVCC để lại tuple chết, VACUUM dọn chúng để tái sử dụng không
gian. autovacuum chạy tự động nền.

  VACUUM         : đánh dấu không gian tuple chết là tái dùng được
                   (không trả lại OS), cập nhật thống kê.
  VACUUM FULL    : nén bảng, TRẢ không gian cho OS, nhưng KHÓA bảng
                   (tránh chạy giờ cao điểm).
  ANALYZE        : cập nhật thống kê cho planner.

Dấu hiệu cần chú ý: bảng phình to, query chậm dần, transaction id
wraparound (nguy hiểm) -> theo dõi autovacuum.

Ví dụ:
  VACUUM (ANALYZE, VERBOSE) my_table;',
'Because MVCC leaves dead tuples behind, VACUUM cleans them so the
space can be reused. autovacuum runs automatically in the
background.

  VACUUM       : marks dead tuple space as reusable (does not
                 return it to the OS), updates statistics.
  VACUUM FULL  : compacts the table, RETURNS space to the OS, but
                 LOCKS the table (avoid during peak hours).
  ANALYZE      : refreshes statistics for the planner.

Warning signs: growing tables, gradually slower queries,
transaction id wraparound (dangerous) -> monitor autovacuum.

Example:
  VACUUM (ANALYZE, VERBOSE) my_table;',
'[]',140,180),

-- ===== Section 2: Index & Planner =====
('n_pg_btree','B-tree index','Database',
'B-tree là index mặc định, hợp cho so sánh =, <, >, BETWEEN,
ORDER BY và LIKE "abc%" (tiền tố).

SƠ ĐỒ (cây cân bằng, lá liên kết):

        [ 50 | 100 ]            <- nút gốc
         /     |     \
   [..30] [50..80] [100..]      <- nút trong
      │       │        │
    lá ↔    lá ↔      lá ↔      <- lá trỏ tới hàng (liên kết đôi)

Tra cứu ~ O(log n). Lá nối nhau nên quét khoảng (range) nhanh.

Ví dụ + index nhiều cột (thứ tự cột quan trọng):
  CREATE INDEX idx_u_email ON users (email);
  CREATE INDEX idx_o_uid_date ON orders (user_id, created_at);
  -- index (a,b) phục vụ WHERE a=?  và  a=? AND b=?
  -- KHÔNG phục vụ tốt WHERE b=? đơn lẻ',
'B-tree is the default index, good for =, <, >, BETWEEN, ORDER BY,
and LIKE "abc%" (prefix).

DIAGRAM (balanced tree, linked leaves):

        [ 50 | 100 ]            <- root node
         /     |     \
   [..30] [50..80] [100..]      <- internal nodes
      │       │        │
    leaf ↔  leaf ↔   leaf ↔     <- leaves point to rows (doubly linked)

Lookup is ~ O(log n). Leaves are linked so range scans are fast.

Example + multi-column index (column order matters):
  CREATE INDEX idx_u_email ON users (email);
  CREATE INDEX idx_o_uid_date ON orders (user_id, created_at);
  -- index (a,b) serves WHERE a=?  and  a=? AND b=?
  -- does NOT serve WHERE b=? alone well',
'[]',220,120),

('n_pg_index_types','Các loại index khác (GIN/GiST/BRIN)','Database',
'Ngoài B-tree, PostgreSQL có nhiều loại index chuyên biệt:

  GIN   : cho giá trị chứa nhiều phần tử — JSONB, mảng,
          full-text search. Vd: tìm khóa trong JSONB.
  GiST  : dữ liệu hình học, không gian (PostGIS), phạm vi.
  BRIN  : bảng RẤT lớn, dữ liệu sắp theo thứ tự tự nhiên
          (vd log theo thời gian) — index nhỏ gọn.
  Hash  : chỉ cho so sánh = (ít dùng hơn B-tree).

Ví dụ GIN cho JSONB:
  CREATE INDEX idx_doc ON products USING GIN (data);
  SELECT * FROM products WHERE data @> ''{"brand":"acme"}'';

Ví dụ full-text:
  CREATE INDEX idx_fts ON docs USING GIN (to_tsvector(''english'', body));

Chọn đúng loại index theo dạng truy vấn là chìa khóa tối ưu.',
'Besides B-tree, PostgreSQL has several specialized index types:

  GIN   : for values containing many elements - JSONB, arrays,
          full-text search. E.g. find a key inside JSONB.
  GiST  : geometric/spatial data (PostGIS), ranges.
  BRIN  : VERY large tables whose data is naturally ordered
          (e.g. time-series logs) - a tiny index.
  Hash  : only for = comparisons (less used than B-tree).

GIN example for JSONB:
  CREATE INDEX idx_doc ON products USING GIN (data);
  SELECT * FROM products WHERE data @> ''{"brand":"acme"}'';

Full-text example:
  CREATE INDEX idx_fts ON docs USING GIN (to_tsvector(''english'', body));

Choosing the right index type for your query shape is the key to
tuning.',
'[]',300,120),

('n_pg_explain','Đọc EXPLAIN ANALYZE','Database',
'EXPLAIN cho biết KẾ HOẠCH planner chọn; thêm ANALYZE để chạy thật
và xem thời gian/row thực tế.

  EXPLAIN ANALYZE
  SELECT * FROM orders WHERE user_id = 42;

Đọc từ trong ra ngoài. Các node hay gặp:
  Seq Scan     : quét toàn bảng (xấu nếu bảng lớn + có điều kiện lọc)
  Index Scan   : dùng index rồi lấy hàng
  Bitmap Scan  : nhiều hàng rải rác -> gom qua bitmap
  Nested Loop / Hash Join / Merge Join : cách nối bảng

Điều cần soi:
  • cost=... (ước lượng) vs actual time=... (thực tế)
  • rows ước lượng vs rows thật lệch nhiều -> thống kê cũ, chạy ANALYZE
  • Seq Scan trên bảng lớn -> cân nhắc thêm index',
'EXPLAIN shows the PLAN the planner picked; add ANALYZE to actually
run it and see real time/rows.

  EXPLAIN ANALYZE
  SELECT * FROM orders WHERE user_id = 42;

Read from the inside out. Common nodes:
  Seq Scan     : full table scan (bad on a large filtered table)
  Index Scan   : use an index then fetch rows
  Bitmap Scan  : many scattered rows -> gather via a bitmap
  Nested Loop / Hash Join / Merge Join : join strategies

What to inspect:
  • cost=... (estimate) vs actual time=... (real)
  • estimated rows vs real rows differing a lot -> stale stats,
    run ANALYZE
  • Seq Scan on a big table -> consider adding an index',
'[]',220,180),

('n_pg_planner','Query Planner & Thống kê','Database',
'Planner là bộ tối ưu DỰA TRÊN CHI PHÍ (cost-based): nó ước lượng
chi phí nhiều kế hoạch rồi chọn cái rẻ nhất, dựa vào THỐNG KÊ về
phân bố dữ liệu (pg_statistic, cập nhật bởi ANALYZE).

Vì sao planner bỏ qua index của bạn?
  • Bảng nhỏ -> Seq Scan nhanh hơn dùng index.
  • Điều kiện khớp quá nhiều hàng (vd > ~5-10% bảng) -> quét tuần
    tự rẻ hơn.
  • Thống kê cũ -> ước lượng sai -> chọn nhầm. Chạy ANALYZE.
  • Hàm bọc quanh cột (WHERE lower(email)=...) làm index thường
    vô dụng -> cần expression index.

Mẹo: nâng default_statistics_target cho cột lệch phân bố; dùng
EXPLAIN ANALYZE để xác nhận thay vì đoán.',
'The planner is a COST-BASED optimizer: it estimates the cost of
several plans and picks the cheapest, using STATISTICS about data
distribution (pg_statistic, updated by ANALYZE).

Why does the planner ignore your index?
  • Small table -> a Seq Scan is faster than using an index.
  • The predicate matches too many rows (e.g. > ~5-10% of the
    table) -> a sequential scan is cheaper.
  • Stale statistics -> wrong estimate -> wrong choice. Run ANALYZE.
  • A function wrapped around a column (WHERE lower(email)=...)
    makes a normal index useless -> use an expression index.

Tip: raise default_statistics_target for skewed columns; use
EXPLAIN ANALYZE to confirm instead of guessing.',
'[]',300,180),

-- ===== Section 3: Transaction & Isolation =====
('n_pg_isolation','4 mức Isolation & Anomalies','Database',
'Mức cô lập điều chỉnh việc một transaction thấy gì từ transaction
khác. Chuẩn SQL có 4 mức; PostgreSQL mặc định READ COMMITTED.

  Mức               | Dirty read | Non-repeatable | Phantom
  ------------------|-----------|----------------|--------
  READ UNCOMMITTED  | (PG coi như READ COMMITTED)
  READ COMMITTED    | Không     | Có thể         | Có thể
  REPEATABLE READ   | Không     | Không          | Không (PG chặn)
  SERIALIZABLE      | Không     | Không          | Không

Giải nghĩa nhanh:
  • Dirty read: đọc dữ liệu chưa commit.
  • Non-repeatable: đọc lại cùng hàng ra giá trị khác.
  • Phantom: cùng điều kiện, lần sau ra thêm/bớt hàng.

Ví dụ:
  BEGIN ISOLATION LEVEL REPEATABLE READ;
    SELECT ... ; -- snapshot cố định suốt transaction
  COMMIT;

PG dùng snapshot MVCC nên REPEATABLE READ đã chặn cả phantom.',
'The isolation level controls what one transaction sees from
others. The SQL standard defines 4 levels; PostgreSQL defaults to
READ COMMITTED.

  Level             | Dirty read | Non-repeatable | Phantom
  ------------------|-----------|----------------|--------
  READ UNCOMMITTED  | (PG treats this as READ COMMITTED)
  READ COMMITTED    | No        | Possible       | Possible
  REPEATABLE READ   | No        | No             | No (PG prevents)
  SERIALIZABLE      | No        | No             | No

Quick definitions:
  • Dirty read: reading uncommitted data.
  • Non-repeatable: re-reading the same row yields a different value.
  • Phantom: the same predicate returns more/fewer rows next time.

Example:
  BEGIN ISOLATION LEVEL REPEATABLE READ;
    SELECT ... ; -- a fixed snapshot for the whole transaction
  COMMIT;

PG uses MVCC snapshots, so REPEATABLE READ already prevents
phantoms too.',
'[]',20,380),

('n_pg_locking','Lock & Deadlock','Database',
'PostgreSQL khóa ở nhiều mức. Người ĐỌC thường không chặn người
GHI (nhờ MVCC), nhưng hai người GHI cùng hàng thì chờ nhau.

Khóa hàng chủ động:
  SELECT * FROM accounts WHERE id=1 FOR UPDATE;  -- giữ hàng để sửa
  SELECT ... FOR SHARE;                           -- chặn ghi, cho đọc

Deadlock: A giữ hàng 1 chờ hàng 2, B giữ hàng 2 chờ hàng 1.
PostgreSQL TỰ phát hiện và hủy một transaction (báo deadlock).

Tránh deadlock:
  • Luôn khóa các hàng theo CÙNG một thứ tự ở mọi nơi.
  • Giữ transaction NGẮN.
  • Dùng SELECT ... FOR UPDATE SKIP LOCKED cho hàng đợi công việc.',
'PostgreSQL locks at several levels. READERS usually do not block
WRITERS (thanks to MVCC), but two WRITERS on the same row wait for
each other.

Explicit row locks:
  SELECT * FROM accounts WHERE id=1 FOR UPDATE;  -- hold a row to edit
  SELECT ... FOR SHARE;                           -- block writes, allow reads

Deadlock: A holds row 1 waiting for row 2, B holds row 2 waiting
for row 1. PostgreSQL DETECTS this automatically and aborts one
transaction (reports a deadlock).

Avoiding deadlocks:
  • Always lock rows in the SAME order everywhere.
  • Keep transactions SHORT.
  • Use SELECT ... FOR UPDATE SKIP LOCKED for job queues.',
'[]',100,380),

('n_pg_txn','Transaction & Savepoint','Database',
'Transaction gom nhiều câu lệnh thành một đơn vị ACID: hoặc thành
công tất cả (COMMIT) hoặc hủy tất cả (ROLLBACK).

  BEGIN;
    UPDATE accounts SET bal = bal - 100 WHERE id = 1;
    UPDATE accounts SET bal = bal + 100 WHERE id = 2;
  COMMIT;   -- cả hai cùng thành công, nếu lỗi giữa chừng -> ROLLBACK

Savepoint — rollback một phần:
  BEGIN;
    INSERT ...;
    SAVEPOINT sp1;
    UPDATE ...;         -- lỡ lỗi
    ROLLBACK TO sp1;    -- chỉ hủy từ sp1, giữ INSERT
  COMMIT;

Lưu ý: transaction mở lâu giữ snapshot -> cản VACUUM dọn tuple chết.
Giữ giao dịch ngắn gọn.',
'A transaction groups statements into one ACID unit: either all
succeed (COMMIT) or all are undone (ROLLBACK).

  BEGIN;
    UPDATE accounts SET bal = bal - 100 WHERE id = 1;
    UPDATE accounts SET bal = bal + 100 WHERE id = 2;
  COMMIT;   -- both succeed together; on a mid-way error -> ROLLBACK

Savepoint - partial rollback:
  BEGIN;
    INSERT ...;
    SAVEPOINT sp1;
    UPDATE ...;         -- suppose this errors
    ROLLBACK TO sp1;    -- undo only from sp1, keep the INSERT
  COMMIT;

Note: a long-open transaction holds a snapshot -> it blocks VACUUM
from cleaning dead tuples. Keep transactions short.',
'[]',20,440),

-- ===== Section 4: Tính năng nâng cao =====
('n_pg_jsonb','JSONB','Database',
'JSONB lưu JSON ở dạng nhị phân đã phân giải -> truy vấn nhanh, hỗ
trợ index; khác json (lưu text nguyên văn, chậm khi truy vấn).

Toán tử hay dùng:
  data->''key''      -> lấy giá trị (trả jsonb)
  data->>''key''     -> lấy giá trị (trả text)
  data @> ''{...}''  -> chứa (containment)  -- dùng được GIN index

Ví dụ:
  CREATE TABLE products (id serial, data jsonb);
  CREATE INDEX idx_data ON products USING GIN (data);
  SELECT * FROM products
   WHERE data @> ''{"brand":"acme"}''
     AND (data->>''price'')::int > 100;

Dùng JSONB cho dữ liệu bán cấu trúc/linh hoạt; vẫn nên chuẩn hóa
những trường truy vấn/nối bảng nhiều.',
'JSONB stores JSON in a parsed binary form -> fast queries and
index support; unlike json (stores raw text, slow to query).

Common operators:
  data->''key''      -> get value (returns jsonb)
  data->>''key''     -> get value (returns text)
  data @> ''{...}''  -> containment  -- can use a GIN index

Example:
  CREATE TABLE products (id serial, data jsonb);
  CREATE INDEX idx_data ON products USING GIN (data);
  SELECT * FROM products
   WHERE data @> ''{"brand":"acme"}''
     AND (data->>''price'')::int > 100;

Use JSONB for semi-structured/flexible data; still normalize the
fields you frequently filter or join on.',
'[]',220,380),

('n_pg_cte_window','CTE & Window Functions','Database',
'CTE (WITH) đặt tên cho truy vấn con -> dễ đọc; hỗ trợ đệ quy.
Window function tính toán TRÊN một khung hàng mà KHÔNG gộp nhóm.

CTE:
  WITH recent AS (
    SELECT * FROM orders WHERE created_at > now() - interval ''7 days''
  )
  SELECT user_id, count(*) FROM recent GROUP BY user_id;

Window (giữ nguyên từng hàng, thêm cột tính toán):
  SELECT name, dept, salary,
         rank()      OVER (PARTITION BY dept ORDER BY salary DESC),
         avg(salary) OVER (PARTITION BY dept)
  FROM employees;

CTE đệ quy (duyệt cây/đồ thị):
  WITH RECURSIVE tree AS (
    SELECT id, parent_id FROM cat WHERE id = 1
    UNION ALL
    SELECT c.id, c.parent_id FROM cat c JOIN tree t ON c.parent_id = t.id
  ) SELECT * FROM tree;',
'A CTE (WITH) names a subquery -> more readable; supports recursion.
A window function computes OVER a frame of rows WITHOUT collapsing
them into groups.

CTE:
  WITH recent AS (
    SELECT * FROM orders WHERE created_at > now() - interval ''7 days''
  )
  SELECT user_id, count(*) FROM recent GROUP BY user_id;

Window (keeps each row, adds computed columns):
  SELECT name, dept, salary,
         rank()      OVER (PARTITION BY dept ORDER BY salary DESC),
         avg(salary) OVER (PARTITION BY dept)
  FROM employees;

Recursive CTE (walk a tree/graph):
  WITH RECURSIVE tree AS (
    SELECT id, parent_id FROM cat WHERE id = 1
    UNION ALL
    SELECT c.id, c.parent_id FROM cat c JOIN tree t ON c.parent_id = t.id
  ) SELECT * FROM tree;',
'[]',300,380),

('n_pg_types','Kiểu dữ liệu phong phú','Database',
'PostgreSQL nổi bật vì hệ kiểu giàu, giảm nhu cầu xử lý ở app:

  uuid            : khóa phân tán (gen_random_uuid())
  array           : mảng, vd int[] , text[]
  enum            : tập giá trị cố định
  range           : khoảng (int4range, tstzrange) + exclusion constraint
  hstore/jsonb    : key-value / tài liệu
  inet/cidr       : địa chỉ mạng
  tsvector        : full-text search

Ví dụ mảng + range:
  CREATE TABLE ev (id serial, tags text[], during tstzrange);
  SELECT * FROM ev WHERE ''vip'' = ANY(tags);
  -- chặn đặt phòng trùng giờ bằng exclusion constraint trên range

Có thể tự tạo type/domain riêng. Dùng đúng kiểu giúp ràng buộc dữ
liệu chặt và query gọn hơn.',
'PostgreSQL stands out for its rich type system, reducing app-side
handling:

  uuid            : distributed keys (gen_random_uuid())
  array           : arrays, e.g. int[] , text[]
  enum            : a fixed set of values
  range           : ranges (int4range, tstzrange) + exclusion constraint
  hstore/jsonb    : key-value / document
  inet/cidr       : network addresses
  tsvector        : full-text search

Array + range example:
  CREATE TABLE ev (id serial, tags text[], during tstzrange);
  SELECT * FROM ev WHERE ''vip'' = ANY(tags);
  -- prevent overlapping bookings via an exclusion constraint on the range

You can define custom types/domains. Using the right type enforces
data constraints tightly and keeps queries cleaner.',
'[]',220,440),

('n_pg_partition','Partitioning','Database',
'Partitioning chia một bảng lớn thành nhiều bảng con theo khóa,
giúp query chỉ quét phần liên quan (partition pruning) và bảo trì
dễ (xóa cả partition cũ thay vì DELETE hàng loạt).

Kiểu phân mảnh:
  RANGE  : theo khoảng (vd theo tháng/ngày) — phổ biến cho log
  LIST   : theo danh sách giá trị (vd theo quốc gia)
  HASH   : chia đều theo băm

Ví dụ RANGE theo thời gian:
  CREATE TABLE logs (id bigint, ts timestamptz, msg text)
    PARTITION BY RANGE (ts);
  CREATE TABLE logs_2026_01 PARTITION OF logs
    FOR VALUES FROM (''2026-01-01'') TO (''2026-02-01'');

Planner tự loại các partition không khớp WHERE -> nhanh hơn nhiều
trên bảng cực lớn. Kết hợp BRIN index cho dữ liệu theo thời gian.',
'Partitioning splits a large table into child tables by a key, so
queries scan only the relevant part (partition pruning) and
maintenance is easy (drop a whole old partition instead of a mass
DELETE).

Partition kinds:
  RANGE  : by range (e.g. by month/day) - common for logs
  LIST   : by a list of values (e.g. by country)
  HASH   : evenly split by hash

RANGE by time example:
  CREATE TABLE logs (id bigint, ts timestamptz, msg text)
    PARTITION BY RANGE (ts);
  CREATE TABLE logs_2026_01 PARTITION OF logs
    FOR VALUES FROM (''2026-01-01'') TO (''2026-02-01'');

The planner prunes partitions that do not match WHERE -> much
faster on huge tables. Combine with a BRIN index for time-series
data.',
'[]',300,440)
ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ------------------------- EDGES -----------------------------------
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_pg_part-of','root','t_pg','part-of'),
('e_t_pg_s_pg_1_part-of','t_pg','s_pg_1','part-of'),
('e_t_pg_s_pg_2_part-of','t_pg','s_pg_2','part-of'),
('e_t_pg_s_pg_3_part-of','t_pg','s_pg_3','part-of'),
('e_t_pg_s_pg_4_part-of','t_pg','s_pg_4','part-of'),
('e_s_pg_1_n_pg_arch','s_pg_1','n_pg_arch','part-of'),
('e_s_pg_1_n_pg_mvcc','s_pg_1','n_pg_mvcc','part-of'),
('e_s_pg_1_n_pg_wal','s_pg_1','n_pg_wal','part-of'),
('e_s_pg_1_n_pg_vacuum','s_pg_1','n_pg_vacuum','part-of'),
('e_s_pg_2_n_pg_btree','s_pg_2','n_pg_btree','part-of'),
('e_s_pg_2_n_pg_index_types','s_pg_2','n_pg_index_types','part-of'),
('e_s_pg_2_n_pg_explain','s_pg_2','n_pg_explain','part-of'),
('e_s_pg_2_n_pg_planner','s_pg_2','n_pg_planner','part-of'),
('e_s_pg_3_n_pg_isolation','s_pg_3','n_pg_isolation','part-of'),
('e_s_pg_3_n_pg_locking','s_pg_3','n_pg_locking','part-of'),
('e_s_pg_3_n_pg_txn','s_pg_3','n_pg_txn','part-of'),
('e_s_pg_4_n_pg_jsonb','s_pg_4','n_pg_jsonb','part-of'),
('e_s_pg_4_n_pg_cte_window','s_pg_4','n_pg_cte_window','part-of'),
('e_s_pg_4_n_pg_types','s_pg_4','n_pg_types','part-of'),
('e_s_pg_4_n_pg_partition','s_pg_4','n_pg_partition','part-of'),
('e_n_pg_mvcc_n_pg_vacuum_rel','n_pg_mvcc','n_pg_vacuum','related'),
('e_n_pg_btree_n_pg_explain_rel','n_pg_btree','n_pg_explain','related'),
('e_t_pg_q_8_related','t_pg','q_8','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);


-- ===== TOPIC: MySQL Core (xem seed_mysql.sql) =====
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_mysql','MySQL Core','Database',
'Kiến thức chuyên sâu về MySQL/InnoDB: kiến trúc tầng + storage engine, index B+Tree (clustered/secondary), transaction & khóa (gap/next-key lock), MVCC, tối ưu truy vấn và replication. Kèm so sánh với PostgreSQL.',
'In-depth MySQL/InnoDB: layered architecture + storage engine, B+Tree indexes (clustered/secondary), transactions & locking (gap/next-key locks), MVCC, query tuning, and replication. Includes a comparison with PostgreSQL.',
'[]',1800,300),

('s_my_1','Kiến trúc & InnoDB','Database',
'Kiến trúc tầng của MySQL, storage engine, và nội tại InnoDB (buffer pool, redo/undo log).',
'The layered architecture of MySQL, storage engines, and InnoDB internals (buffer pool, redo/undo logs).',
'[]',1720,180),
('s_my_2','Index (B+Tree)','Database',
'Clustered vs secondary index, covering/composite index và cách đọc EXPLAIN.',
'Clustered vs secondary indexes, covering/composite indexes, and reading EXPLAIN.',
'[]',1900,180),
('s_my_3','Transaction & Locking','Database',
'Mức isolation, MVCC của InnoDB, và các loại khóa (row, gap, next-key).',
'Isolation levels, InnoDB MVCC, and lock types (row, gap, next-key).',
'[]',1720,440),
('s_my_4','Tối ưu & Vận hành','Database',
'Tối ưu truy vấn, slow query log, replication và so sánh với PostgreSQL.',
'Query tuning, the slow query log, replication, and a comparison with PostgreSQL.',
'[]',1900,440),

-- ===== Section 1 =====
('n_my_arch','Kiến trúc tầng & Storage Engine','Database',
'MySQL tách rõ 2 tầng: tầng SQL (chung) và tầng storage engine
(cắm được — pluggable). Đây là nét đặc trưng so với PostgreSQL.

SƠ ĐỒ:

  Client
    │  (giao thức MySQL)
    ▼
  ┌ SQL Layer (chung cho mọi engine) ───────────┐
  │  connection/thread, parser, optimizer, cache │
  └───────────────────────────────────────────────┘
    │  Handler API
    ▼
  ┌ Storage Engine (cắm được) ──────────────────┐
  │  InnoDB (mặc định, có transaction) | MyISAM  │
  └───────────────────────────────────────────────┘
    │
    ▼
  Files trên đĩa

Khác PostgreSQL (đa tiến trình), MySQL dùng ĐA LUỒNG: mỗi kết nối
là một thread trong cùng process -> nhẹ hơn khi nhiều kết nối,
nhưng vẫn nên dùng pool.',
'MySQL clearly separates 2 layers: the SQL layer (shared) and the
storage engine layer (pluggable). This is a defining trait versus
PostgreSQL.

DIAGRAM:

  Client
    │  (MySQL protocol)
    ▼
  ┌ SQL Layer (shared by all engines) ──────────┐
  │  connection/thread, parser, optimizer, cache │
  └───────────────────────────────────────────────┘
    │  Handler API
    ▼
  ┌ Storage Engine (pluggable) ─────────────────┐
  │  InnoDB (default, transactional) | MyISAM    │
  └───────────────────────────────────────────────┘
    │
    ▼
  Files on disk

Unlike PostgreSQL (multi-process), MySQL is MULTI-THREADED: each
connection is a thread within one process -> lighter with many
connections, but you should still use a pool.',
'[]',1680,120),

('n_my_innodb','InnoDB internals','Database',
'InnoDB là engine mặc định, có ACID, MVCC và khóa mức hàng.

Thành phần chính:
  Buffer Pool : cache trang dữ liệu + index trong RAM (cấu hình
                innodb_buffer_pool_size, quan trọng nhất cho hiệu năng)
  Redo log    : ghi trước thay đổi để phục hồi sau crash (giống WAL)
  Undo log    : lưu bản cũ của hàng -> phục vụ MVCC + rollback
  Doublewrite : chống trang ghi dở khi crash

Luồng ghi (tương tự WAL của PG):
  sửa trang trong buffer pool -> ghi redo log (bền khi commit)
  -> flush trang xuống đĩa sau (checkpoint)

Chỉnh innodb_buffer_pool_size ~ 60-75% RAM cho server chuyên DB là
đòn bẩy hiệu năng lớn nhất.',
'InnoDB is the default engine, providing ACID, MVCC, and row-level
locking.

Main components:
  Buffer Pool : caches data + index pages in RAM (configured by
                innodb_buffer_pool_size, the most important for perf)
  Redo log    : logs changes ahead for crash recovery (like WAL)
  Undo log    : keeps old row versions -> powers MVCC + rollback
  Doublewrite : protects against torn page writes on crash

Write flow (similar to PG WAL):
  modify a page in the buffer pool -> write the redo log (durable on
  commit) -> flush pages to disk later (checkpoint)

Setting innodb_buffer_pool_size ~ 60-75% of RAM on a dedicated DB
server is the biggest performance lever.',
'[]',1760,120),

('n_my_engines','InnoDB vs MyISAM','Database',
'Nhờ kiến trúc cắm engine, MySQL có nhiều engine; hai cái kinh điển:

  Tiêu chí       | InnoDB (mặc định)     | MyISAM (cũ)
  ---------------|-----------------------|--------------------
  Transaction    | Có (ACID)             | KHÔNG
  Khóa           | Mức hàng (row)        | Mức bảng (table)
  Khóa ngoại     | Có                    | Không
  Crash recovery | Có (redo log)         | Yếu
  Phù hợp        | OLTP, ghi nhiều       | đọc thuần, ít ghi

Kết luận: hầu như luôn dùng InnoDB. MyISAM chỉ còn ở hệ thống cũ
hoặc bảng chỉ đọc rất đơn giản. Các engine khác: MEMORY (RAM),
ARCHIVE (nén, chỉ ghi thêm).

Kiểm tra engine:
  SHOW TABLE STATUS WHERE Name = ''orders'';',
'Thanks to the pluggable-engine design, MySQL has several engines;
the two classic ones:

  Criteria       | InnoDB (default)      | MyISAM (legacy)
  ---------------|-----------------------|--------------------
  Transactions   | Yes (ACID)            | NO
  Locking        | Row-level             | Table-level
  Foreign keys   | Yes                   | No
  Crash recovery | Yes (redo log)        | Weak
  Best for       | OLTP, write-heavy     | read-only, few writes

Conclusion: almost always use InnoDB. MyISAM only remains in legacy
systems or very simple read-only tables. Other engines: MEMORY
(RAM), ARCHIVE (compressed, append-only).

Check the engine:
  SHOW TABLE STATUS WHERE Name = ''orders'';',
'[]',1680,180),

-- ===== Section 2: Index =====
('n_my_btree','Clustered vs Secondary index','Database',
'InnoDB lưu bảng NHƯ một B+Tree theo PRIMARY KEY — gọi là clustered
index: dữ liệu hàng nằm NGAY trong lá của cây PK. Đây là khác biệt
lớn với PostgreSQL (heap tách rời).

SƠ ĐỒ tra cứu qua secondary index:

  Secondary index (vd theo email)
     lá chứa: email -> PRIMARY KEY (không phải con trỏ hàng)
                          │
                          ▼  (lookup lần 2)
  Clustered index (theo PK)
     lá chứa: PK -> TOÀN BỘ dữ liệu hàng

=> Tra cứu qua secondary index tốn 2 bước (gọi là bookmark lookup).

HỆ QUẢ THỰC TẾ:
  • PK nên NHỎ và tăng dần (vd BIGINT AUTO_INCREMENT). PK ngẫu nhiên
    (UUID v4) làm chèn phân mảnh, phình secondary index.
  • Mọi secondary index đều ngầm chứa PK.',
'InnoDB stores the table AS a B+Tree ordered by the PRIMARY KEY -
the clustered index: the row data lives RIGHT in the leaves of the
PK tree. This is a big difference from PostgreSQL (a separate heap).

DIAGRAM of a lookup via a secondary index:

  Secondary index (e.g. by email)
     leaf holds: email -> PRIMARY KEY (not a row pointer)
                            │
                            ▼  (second lookup)
  Clustered index (by PK)
     leaf holds: PK -> the WHOLE row data

=> A lookup via a secondary index takes 2 steps (a bookmark lookup).

REAL-WORLD CONSEQUENCES:
  • The PK should be SMALL and increasing (e.g. BIGINT AUTO_INCREMENT).
    A random PK (UUID v4) causes fragmented inserts and bloats
    secondary indexes.
  • Every secondary index implicitly contains the PK.',
'[]',1860,120),

('n_my_covering','Covering & Composite index','Database',
'Composite index nhiều cột tuân luật TIỀN TỐ TRÁI NHẤT (leftmost
prefix): index (a,b,c) phục vụ WHERE a, (a,b), (a,b,c) — KHÔNG phục
vụ tốt WHERE b hay c đơn lẻ.

Covering index: index chứa ĐỦ mọi cột câu query cần -> đọc xong ở
index, KHỎI phải về clustered index (rất nhanh).

Ví dụ:
  CREATE INDEX idx_uid_status_amt ON orders (user_id, status, amount);

  -- COVERING (chỉ đọc index, EXPLAIN thấy "Using index"):
  SELECT status, amount FROM orders
   WHERE user_id = 42 AND status = ''paid'';

  -- KHÔNG dùng được index tốt (bỏ qua cột đầu):
  SELECT * FROM orders WHERE status = ''paid'';

Thứ tự cột: đặt cột lọc bằng (=) trước, cột phạm vi (>, <) sau.',
'A multi-column composite index follows the LEFTMOST PREFIX rule:
index (a,b,c) serves WHERE a, (a,b), (a,b,c) - it does NOT serve
WHERE b or c alone well.

Covering index: an index that contains ALL columns the query needs
-> the read finishes at the index, NO trip back to the clustered
index (very fast).

Example:
  CREATE INDEX idx_uid_status_amt ON orders (user_id, status, amount);

  -- COVERING (index-only, EXPLAIN shows "Using index"):
  SELECT status, amount FROM orders
   WHERE user_id = 42 AND status = ''paid'';

  -- Cannot use the index well (skips the first column):
  SELECT * FROM orders WHERE status = ''paid'';

Column order: put equality (=) columns first, range (>, <) columns
last.',
'[]',1940,120),

('n_my_explain','Đọc EXPLAIN (MySQL)','Database',
'EXPLAIN cho biết optimizer định thực thi thế nào. Các cột quan trọng:

  type   : kiểu truy cập, từ TỐT đến XẤU:
           const > eq_ref > ref > range > index > ALL
           (ALL = full table scan, thường cần tránh)
  key    : index thực sự được dùng (NULL = không dùng index)
  rows   : ước lượng số hàng phải đọc
  Extra  : "Using index" (covering, tốt),
           "Using filesort"/"Using temporary" (thường tốn kém)

Ví dụ:
  EXPLAIN SELECT * FROM orders WHERE user_id = 42;
  EXPLAIN ANALYZE SELECT ... ;   -- MySQL 8: có thời gian thực tế

Quy trình: thấy type=ALL trên bảng lớn -> thêm index; thấy
filesort/temporary -> cân nhắc index cho ORDER BY/GROUP BY.',
'EXPLAIN shows how the optimizer plans to execute. Key columns:

  type   : access type, from GOOD to BAD:
           const > eq_ref > ref > range > index > ALL
           (ALL = full table scan, usually to be avoided)
  key    : the index actually used (NULL = no index used)
  rows   : estimated number of rows to read
  Extra  : "Using index" (covering, good),
           "Using filesort"/"Using temporary" (often expensive)

Example:
  EXPLAIN SELECT * FROM orders WHERE user_id = 42;
  EXPLAIN ANALYZE SELECT ... ;   -- MySQL 8: shows real timing

Process: see type=ALL on a big table -> add an index; see
filesort/temporary -> consider an index for ORDER BY/GROUP BY.',
'[]',1860,180),

-- ===== Section 3: Transaction & Locking =====
('n_my_isolation','Isolation & MVCC (InnoDB)','Database',
'InnoDB mặc định REPEATABLE READ (khác PostgreSQL mặc định READ
COMMITTED). InnoDB dùng MVCC qua UNDO LOG + READ VIEW.

  READ COMMITTED  : mỗi câu lệnh thấy snapshot mới nhất đã commit
  REPEATABLE READ : cả transaction dùng CÙNG một read view
                    (đặt ở lần đọc đầu) -> đọc lặp lại nhất quán
  SERIALIZABLE    : biến SELECT thành khóa chia sẻ

Cơ chế MVCC: khi đọc, InnoDB dựng lại phiên bản hàng phù hợp với
read view bằng cách lần theo undo log -> người đọc không chặn ghi.

Ví dụ:
  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
  START TRANSACTION;  SELECT ... ;  COMMIT;

Điểm đặc biệt: REPEATABLE READ + gap lock giúp InnoDB chống phantom
trong nhiều trường hợp (xem node Locking).',
'InnoDB defaults to REPEATABLE READ (unlike PostgreSQL, which
defaults to READ COMMITTED). InnoDB does MVCC via the UNDO LOG +
a READ VIEW.

  READ COMMITTED  : each statement sees the latest committed snapshot
  REPEATABLE READ : the whole transaction uses the SAME read view
                    (taken at the first read) -> consistent repeated reads
  SERIALIZABLE    : turns SELECT into a shared lock

MVCC mechanism: on read, InnoDB reconstructs the row version that
matches the read view by walking the undo log -> readers do not
block writers.

Example:
  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
  START TRANSACTION;  SELECT ... ;  COMMIT;

Notable: REPEATABLE READ + gap locks let InnoDB prevent phantoms in
many cases (see the Locking node).',
'[]',1680,380),

('n_my_locking','Row / Gap / Next-key lock & Deadlock','Database',
'InnoDB khóa mức HÀNG, nhưng để chống phantom ở REPEATABLE READ nó
còn khóa cả KHOẢNG TRỐNG giữa các hàng.

  Record lock  : khóa đúng một hàng chỉ mục
  Gap lock     : khóa khoảng trống giữa 2 giá trị index (chặn chèn)
  Next-key lock: record lock + gap lock (mặc định ở REPEATABLE READ)

Ví dụ khóa để cập nhật an toàn:
  START TRANSACTION;
    SELECT * FROM accounts WHERE id = 1 FOR UPDATE;  -- khóa hàng
    UPDATE accounts SET bal = bal - 100 WHERE id = 1;
  COMMIT;

Deadlock: hai transaction chờ khóa của nhau. InnoDB tự phát hiện và
rollback transaction rẻ hơn (báo lỗi 1213). Ứng dụng nên RETRY.

Tránh: khóa theo cùng thứ tự, transaction ngắn, index đúng để giảm
số hàng bị khóa (thiếu index -> khóa lan rộng).',
'InnoDB locks at the ROW level, but to prevent phantoms under
REPEATABLE READ it also locks the GAPS between rows.

  Record lock  : locks exactly one index row
  Gap lock     : locks the gap between two index values (blocks inserts)
  Next-key lock: record lock + gap lock (default under REPEATABLE READ)

Example of locking for a safe update:
  START TRANSACTION;
    SELECT * FROM accounts WHERE id = 1 FOR UPDATE;  -- lock the row
    UPDATE accounts SET bal = bal - 100 WHERE id = 1;
  COMMIT;

Deadlock: two transactions wait on each other locks. InnoDB detects
it and rolls back the cheaper one (error 1213). The app should RETRY.

Avoid: lock in the same order, keep transactions short, and have
proper indexes to reduce locked rows (a missing index -> locks
spread widely).',
'[]',1760,380),

-- ===== Section 4: Tối ưu & Vận hành =====
('n_my_optimize','Tối ưu truy vấn & Slow query log','Database',
'Quy trình tối ưu thực dụng:

  1. Bật slow query log để tìm truy vấn chậm:
       SET GLOBAL slow_query_log = ON;
       SET GLOBAL long_query_time = 1;   -- >1s bị ghi lại
  2. Chạy EXPLAIN để xem type/key/rows/Extra.
  3. Thêm index đúng (composite, covering) theo mẫu WHERE/ORDER BY.
  4. Tránh anti-pattern:
       • N+1 query (vòng lặp truy vấn) -> JOIN hoặc IN (...)
       • SELECT *  -> chỉ chọn cột cần (tận dụng covering index)
       • Hàm bọc cột: WHERE DATE(created_at)=... -> index vô dụng
       • OFFSET lớn khi phân trang -> dùng keyset pagination
         (WHERE id > last_id LIMIT n)

Đo lại sau mỗi thay đổi; đừng thêm index tràn lan (index làm chậm
ghi và tốn dung lượng).',
'A practical tuning workflow:

  1. Enable the slow query log to find slow queries:
       SET GLOBAL slow_query_log = ON;
       SET GLOBAL long_query_time = 1;   -- >1s is logged
  2. Run EXPLAIN to inspect type/key/rows/Extra.
  3. Add the right index (composite, covering) matching your
     WHERE/ORDER BY shape.
  4. Avoid anti-patterns:
       • N+1 queries (querying in a loop) -> JOIN or IN (...)
       • SELECT *  -> select only needed columns (enable covering)
       • Function-wrapped columns: WHERE DATE(created_at)=... -> index unused
       • Large OFFSET pagination -> use keyset pagination
         (WHERE id > last_id LIMIT n)

Measure again after each change; do not add indexes everywhere
(indexes slow writes and cost space).',
'[]',1860,380),

('n_my_replication','Replication','Database',
'Replication sao chép dữ liệu từ primary (source) sang replica dựa
trên BINLOG — nhật ký ghi lại mọi thay đổi.

SƠ ĐỒ:
  Primary --(binlog)--> Replica I/O thread --> relay log
                                                   │
                                          Replica SQL thread applies
                                                   ▼
                                             Replica data

Chế độ bền vững:
  • Async (mặc định)  : primary không chờ replica -> nhanh, nhưng
    có thể mất dữ liệu nếu primary sập trước khi replica nhận kịp.
  • Semi-sync         : primary chờ ÍT NHẤT 1 replica xác nhận đã
    nhận -> an toàn hơn, chậm hơn chút.

Dùng để: mở rộng đọc (đọc từ replica), backup, và failover (nâng
replica lên primary). Lưu ý độ trễ replica (replication lag) khi
đọc-sau-ghi.',
'Replication copies data from a primary (source) to replicas based
on the BINLOG - a log recording every change.

DIAGRAM:
  Primary --(binlog)--> Replica I/O thread --> relay log
                                                   │
                                          Replica SQL thread applies
                                                   ▼
                                             Replica data

Durability modes:
  • Async (default)  : the primary does not wait for the replica ->
    fast, but data may be lost if the primary crashes before the
    replica catches up.
  • Semi-sync        : the primary waits for AT LEAST 1 replica to
    acknowledge receipt -> safer, slightly slower.

Used for: read scaling (read from replicas), backups, and failover
(promote a replica to primary). Watch replication lag for
read-after-write consistency.',
'[]',1940,380),

('n_my_pg_vs_my','PostgreSQL vs MySQL','Database',
'Cả hai đều là RDBMS mạnh; chọn theo nhu cầu.

  Tiêu chí        | PostgreSQL              | MySQL (InnoDB)
  ----------------|-------------------------|----------------------
  Kiến trúc       | đa tiến trình           | đa luồng
  Lưu bảng        | heap + index tách       | clustered theo PK
  Isolation mặc   | READ COMMITTED          | REPEATABLE READ
  Kiểu dữ liệu    | rất giàu (JSONB, array, | cơ bản + JSON
                  | range, GIS, custom type)|
  Tính năng SQL   | mạnh (CTE đệ quy, window,| đủ dùng (đã cải thiện
                  | index nâng cao)         | nhiều ở 8.0)
  Nổi bật         | chuẩn SQL, phân tích,    | đơn giản, phổ biến,
                  | dữ liệu phức tạp         | đọc nhanh, hệ sinh thái

Chọn nhanh:
  • Cần kiểu dữ liệu/truy vấn phức tạp, phân tích -> PostgreSQL.
  • Web app phổ thông, đọc nhiều, quen thuộc, nhiều hosting -> MySQL.
Cả hai đều đáp ứng tốt phần lớn dự án; sự khác biệt chỉ rõ ở quy mô
lớn hoặc yêu cầu đặc thù.',
'Both are powerful RDBMSs; choose by need.

  Criteria        | PostgreSQL              | MySQL (InnoDB)
  ----------------|-------------------------|----------------------
  Architecture    | multi-process           | multi-threaded
  Table storage   | heap + separate index   | clustered by PK
  Default isolation| READ COMMITTED         | REPEATABLE READ
  Data types      | very rich (JSONB, array,| basic + JSON
                  | range, GIS, custom)     |
  SQL features    | strong (recursive CTE,  | sufficient (much
                  | window, advanced index) | improved in 8.0)
  Strengths       | SQL-standard, analytics,| simple, popular,
                  | complex data            | fast reads, ecosystem

Quick pick:
  • Need complex data types/queries or analytics -> PostgreSQL.
  • Common web app, read-heavy, familiar, lots of hosting -> MySQL.
Both serve most projects well; differences mainly show at large
scale or special requirements.',
'[]',1860,440)
ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ------------------------- EDGES -----------------------------------
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_mysql_part-of','root','t_mysql','part-of'),
('e_t_mysql_s_my_1_part-of','t_mysql','s_my_1','part-of'),
('e_t_mysql_s_my_2_part-of','t_mysql','s_my_2','part-of'),
('e_t_mysql_s_my_3_part-of','t_mysql','s_my_3','part-of'),
('e_t_mysql_s_my_4_part-of','t_mysql','s_my_4','part-of'),
('e_s_my_1_n_my_arch','s_my_1','n_my_arch','part-of'),
('e_s_my_1_n_my_innodb','s_my_1','n_my_innodb','part-of'),
('e_s_my_1_n_my_engines','s_my_1','n_my_engines','part-of'),
('e_s_my_2_n_my_btree','s_my_2','n_my_btree','part-of'),
('e_s_my_2_n_my_covering','s_my_2','n_my_covering','part-of'),
('e_s_my_2_n_my_explain','s_my_2','n_my_explain','part-of'),
('e_s_my_3_n_my_isolation','s_my_3','n_my_isolation','part-of'),
('e_s_my_3_n_my_locking','s_my_3','n_my_locking','part-of'),
('e_s_my_4_n_my_optimize','s_my_4','n_my_optimize','part-of'),
('e_s_my_4_n_my_replication','s_my_4','n_my_replication','part-of'),
('e_s_my_4_n_my_pg_vs_my','s_my_4','n_my_pg_vs_my','part-of'),
('e_n_my_pg_vs_my_t_pg_related','n_my_pg_vs_my','t_pg','related'),
('e_n_my_innodb_n_my_btree_rel','n_my_innodb','n_my_btree','related'),
('e_t_mysql_q_8_related','t_mysql','q_8','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);


-- ===== TOPIC: Design Patterns (xem seed_patterns.sql) =====
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_dp','Design Patterns','Architecture',
'Các mẫu thiết kế kinh điển (Gang of Four) và nguyên lý SOLID, kèm ví dụ JS/TS: nhóm Creational, Structural, Behavioral, và vài pattern thực tế trong backend.',
'Classic design patterns (Gang of Four) and SOLID principles, with JS/TS examples: the Creational, Structural, and Behavioral groups, plus a few practical backend patterns.',
'[]',150,1650),

('s_dp_1','Nguyên lý & Tổng quan','Architecture',
'Pattern là gì, 3 nhóm GoF, nguyên lý SOLID và vài pattern thực tế trong backend.',
'What a pattern is, the 3 GoF groups, SOLID principles, and a few practical backend patterns.',
'[]',60,1550),
('s_dp_2','Creational','Architecture',
'Các mẫu về cách TẠO object: Singleton, Factory, Builder.',
'Patterns about how to CREATE objects: Singleton, Factory, Builder.',
'[]',260,1550),
('s_dp_3','Structural','Architecture',
'Các mẫu GHÉP object/lớp: Adapter, Decorator, Facade, Proxy.',
'Patterns for COMPOSING objects/classes: Adapter, Decorator, Facade, Proxy.',
'[]',60,1780),
('s_dp_4','Behavioral','Architecture',
'Các mẫu về cách object TƯƠNG TÁC: Strategy, Observer, Command.',
'Patterns about how objects INTERACT: Strategy, Observer, Command.',
'[]',260,1780),

-- ===== Section 1 =====
('n_dp_intro','Design Pattern là gì?','Architecture',
'Design pattern là giải pháp MẪU cho các vấn đề thiết kế lặp lại —
không phải code copy-paste mà là cách tổ chức. Nhóm Gang of Four
(GoF) chia 23 pattern thành 3 nhóm:

  • Creational  : cách TẠO object (Singleton, Factory, Builder...)
  • Structural  : cách GHÉP object/lớp (Adapter, Decorator, Facade)
  • Behavioral  : cách object TƯƠNG TÁC (Strategy, Observer, Command)

Mục đích: code dễ mở rộng, giảm phụ thuộc, dễ test, và tạo NGÔN
NGỮ CHUNG khi trao đổi trong đội (nói "dùng Strategy" là hiểu ngay).

Lưu ý quan trọng: đừng lạm dụng. Chỉ áp pattern khi vấn đề thực sự
xuất hiện; nhồi pattern vào chỗ đơn giản là over-engineering.',
'A design pattern is a TEMPLATE solution to recurring design
problems - not copy-paste code but a way to organize it. The Gang
of Four (GoF) groups 23 patterns into 3 categories:

  • Creational  : how to CREATE objects (Singleton, Factory, Builder)
  • Structural  : how to COMPOSE objects/classes (Adapter, Decorator,
                  Facade)
  • Behavioral  : how objects INTERACT (Strategy, Observer, Command)

Purpose: code that is easier to extend, less coupled, and easier to
test, plus a SHARED VOCABULARY for the team (saying "use Strategy"
is instantly understood).

Important: do not overuse them. Apply a pattern only when the
problem actually appears; forcing patterns into simple code is
over-engineering.',
'[]',20,1490),

('n_dp_solid','SOLID principles','Architecture',
'SOLID là 5 nguyên lý thiết kế hướng đối tượng, nền của nhiều pattern:

  S - Single Responsibility: một lớp chỉ có MỘT lý do để thay đổi.
  O - Open/Closed          : mở để MỞ RỘNG, đóng để SỬA ĐỔI.
  L - Liskov Substitution  : lớp con phải thay được lớp cha mà không
                             phá hành vi.
  I - Interface Segregation: nhiều interface nhỏ, chuyên biệt hơn
                             một interface to.
  D - Dependency Inversion : phụ thuộc ABSTRACTION, không phụ thuộc
                             chi tiết cụ thể.

Ví dụ (D - inject abstraction):
  class OrderService {
    constructor(repo) { this.repo = repo; }  // repo: 1 interface
    save(o) { return this.repo.insert(o); }
  }
  // Đổi repo (Postgres/Mongo) KHÔNG cần sửa OrderService,
  // và dễ mock repo khi test.',
'SOLID is a set of 5 object-oriented design principles, the basis of
many patterns:

  S - Single Responsibility: a class has only ONE reason to change.
  O - Open/Closed          : open to EXTENSION, closed to MODIFICATION.
  L - Liskov Substitution  : a subclass must be substitutable for its
                             base without breaking behavior.
  I - Interface Segregation: many small, specific interfaces beat one
                             large interface.
  D - Dependency Inversion : depend on ABSTRACTIONS, not on concrete
                             details.

Example (D - inject an abstraction):
  class OrderService {
    constructor(repo) { this.repo = repo; }  // repo: an interface
    save(o) { return this.repo.insert(o); }
  }
  // Swapping repo (Postgres/Mongo) needs NO change to OrderService,
  // and repo is easy to mock in tests.',
'[]',100,1490),

('n_dp_backend','Pattern thực tế trong backend','Architecture',
'Vài pattern hay gặp ngoài GoF, rất phổ biến trong Node/backend:

  • Repository : tách logic truy cập dữ liệu khỏi business logic.
      class UserRepo { findById(id){ /* SQL */ } }
    -> service không biết dùng SQL hay Mongo.

  • Dependency Injection : truyền phụ thuộc từ ngoài vào thay vì tự
    tạo bên trong -> dễ test, dễ thay thế (nền của NestJS).

  • Middleware / Chain of Responsibility : xử lý request qua chuỗi
    hàm (Express): auth -> log -> validate -> handler.

  • DTO : object định dạng dữ liệu vào/ra, tách khỏi entity DB.

Những pattern này giải quyết vấn đề thực tế: tách lớp, dễ test, dễ
bảo trì — quan trọng hơn việc thuộc lòng đủ 23 GoF.',
'A few patterns beyond GoF that are very common in Node/backend:

  • Repository : separates data-access logic from business logic.
      class UserRepo { findById(id){ /* SQL */ } }
    -> the service does not know whether it uses SQL or Mongo.

  • Dependency Injection : pass dependencies in from outside instead
    of creating them inside -> easy to test and swap (the basis of
    NestJS).

  • Middleware / Chain of Responsibility : process a request through
    a chain of functions (Express): auth -> log -> validate -> handler.

  • DTO : an object shaping input/output data, separate from the DB
    entity.

These solve real problems: layering, testability, maintainability -
more important than memorizing all 23 GoF patterns.',
'[]',60,1610),

-- ===== Section 2: Creational =====
('n_dp_singleton','Singleton','Architecture',
'Đảm bảo một lớp CHỈ có một instance duy nhất, chia sẻ toàn cục.
Hay dùng cho: connection pool, config, logger.

Trong Node, module được cache nên xuất một instance là singleton
tự nhiên:
  // db.js
  const pool = createPool();
  module.exports = pool;   // mọi require dùng CHUNG một pool

  // a.js và b.js cùng require("./db") -> cùng pool

Cẩn thận: singleton là GLOBAL STATE -> khó test (khó reset giữa
các test), ẩn phụ thuộc, dễ gây coupling. Nhiều trường hợp nên
dùng Dependency Injection thay vì singleton cứng.',
'Ensures a class has only ONE instance, shared globally. Common for:
connection pools, config, loggers.

In Node, modules are cached, so exporting one instance is a natural
singleton:
  // db.js
  const pool = createPool();
  module.exports = pool;   // every require shares the SAME pool

  // a.js and b.js both require("./db") -> same pool

Caution: a singleton is GLOBAL STATE -> hard to test (hard to reset
between tests), hides dependencies, and encourages coupling. Often
prefer Dependency Injection over a hard singleton.',
'[]',220,1490),

('n_dp_factory','Factory','Architecture',
'Factory tách việc TẠO object khỏi nơi sử dụng -> dễ đổi loại
object mà không sửa code gọi.

Factory Method (chọn lớp con lúc chạy):
  function createLogger(type) {
    if (type === "file")  return new FileLogger();
    if (type === "cloud") return new CloudLogger();
    return new ConsoleLogger();
  }
  const log = createLogger(process.env.LOG_TYPE);

Abstract Factory: tạo cả một HỌ object liên quan (vd bộ UI theo
theme: DarkButton + DarkInput).

Dùng khi: việc khởi tạo phức tạp, phụ thuộc cấu hình/điều kiện,
hoặc muốn giấu chi tiết lớp cụ thể khỏi client.',
'A Factory separates object CREATION from its use -> easy to change
the object type without touching the calling code.

Factory Method (pick a subclass at runtime):
  function createLogger(type) {
    if (type === "file")  return new FileLogger();
    if (type === "cloud") return new CloudLogger();
    return new ConsoleLogger();
  }
  const log = createLogger(process.env.LOG_TYPE);

Abstract Factory: creates a whole FAMILY of related objects (e.g. a
themed UI set: DarkButton + DarkInput).

Use when: creation is complex, depends on config/conditions, or you
want to hide concrete classes from the client.',
'[]',300,1490),

('n_dp_builder','Builder','Architecture',
'Builder dựng một object phức tạp theo TỪNG BƯỚC, tránh constructor
với quá nhiều tham số khó nhớ.

Ví dụ (fluent, nối chuỗi):
  const query = new QueryBuilder()
    .select("id", "name")
    .from("users")
    .where("age > 18")
    .orderBy("name")
    .build();   // build() trả về kết quả cuối

So với constructor dài dễ nhầm thứ tự:
  new Query("users", ["id","name"], "age>18", null, "name"); // khó đọc

Dùng khi object có nhiều tùy chọn KHÔNG bắt buộc, hoặc cần dựng
linh hoạt (query builder, HTTP request builder, cấu hình).',
'A Builder constructs a complex object STEP BY STEP, avoiding a
constructor with too many hard-to-remember parameters.

Example (fluent, chained):
  const query = new QueryBuilder()
    .select("id", "name")
    .from("users")
    .where("age > 18")
    .orderBy("name")
    .build();   // build() returns the final result

Versus a long constructor with error-prone order:
  new Query("users", ["id","name"], "age>18", null, "name"); // unreadable

Use when an object has many OPTIONAL settings, or needs flexible
construction (query builder, HTTP request builder, config).',
'[]',220,1610),

-- ===== Section 3: Structural =====
('n_dp_adapter','Adapter','Architecture',
'Adapter là CẦU NỐI giữa hai interface không tương thích — bọc một
API cũ/bên thứ ba thành interface mà app mong đợi.

Ví dụ: app cần interface { pay(amount) } nhưng Stripe có API khác:
  class StripeAdapter {
    constructor(stripe) { this.s = stripe; }
    pay(amount) {
      return this.s.charges.create({ amount, currency: "usd" });
    }
  }
  // app chỉ gọi paymentGateway.pay(100), không biết đó là Stripe

Lợi ích: đổi nhà cung cấp (Stripe -> Paypal) chỉ cần viết adapter
mới, code nghiệp vụ không đổi. Rất hợp khi tích hợp thư viện ngoài.',
'An Adapter is a BRIDGE between two incompatible interfaces - it
wraps a legacy/third-party API into the interface your app expects.

Example: the app needs { pay(amount) } but Stripe has a different API:
  class StripeAdapter {
    constructor(stripe) { this.s = stripe; }
    pay(amount) {
      return this.s.charges.create({ amount, currency: "usd" });
    }
  }
  // the app just calls paymentGateway.pay(100), unaware it is Stripe

Benefit: switching providers (Stripe -> Paypal) only needs a new
adapter; business code stays the same. Great for integrating
external libraries.',
'[]',20,1720),

('n_dp_decorator','Decorator','Architecture',
'Decorator THÊM hành vi cho một object mà không sửa lớp gốc, bằng
cách BỌC nó; có thể ghép nhiều lớp bọc.

Ví dụ (bọc hàm bằng logging + cache):
  const withLogging = fn => (...a) => { console.log(a); return fn(...a); };
  const withCache = fn => {
    const m = new Map();
    return x => m.has(x) ? m.get(x) : (m.set(x, fn(x)), m.get(x));
  };
  const smart = withLogging(withCache(compute));  // ghép chồng

Ứng dụng thực tế: middleware Express (mỗi lớp thêm 1 việc),
TypeScript decorators (@Injectable), higher-order component.

Ưu điểm so với kế thừa: linh hoạt, ghép động lúc chạy, tuân
Open/Closed.',
'A Decorator ADDS behavior to an object without modifying the
original class, by WRAPPING it; multiple wrappers can be composed.

Example (wrap a function with logging + cache):
  const withLogging = fn => (...a) => { console.log(a); return fn(...a); };
  const withCache = fn => {
    const m = new Map();
    return x => m.has(x) ? m.get(x) : (m.set(x, fn(x)), m.get(x));
  };
  const smart = withLogging(withCache(compute));  // stacked

Real-world uses: Express middleware (each layer adds one concern),
TypeScript decorators (@Injectable), higher-order components.

Advantage over inheritance: flexible, composed at runtime, follows
Open/Closed.',
'[]',100,1720),

('n_dp_facade','Facade','Architecture',
'Facade cung cấp MỘT interface đơn giản che giấu một hệ thống con
phức tạp gồm nhiều lớp/bước.

Ví dụ: chuyển đổi video gồm nhiều bước, gói lại sau 1 hàm:
  class MediaConverter {
    convert(file) {
      const raw = this.decoder.decode(file);
      const small = this.resizer.resize(raw);
      const out = this.encoder.encode(small);
      return this.uploader.upload(out);
    }
  }
  media.convert("clip.mov");  // client không cần biết 4 bước bên trong

Lợi ích: giảm ghép nối giữa client và hệ thống con, dễ dùng, dễ
đổi bên trong. Khác Adapter (đổi interface cho tương thích),
Facade chỉ đơn giản hoá.',
'A Facade provides ONE simple interface that hides a complex
subsystem of many classes/steps.

Example: video conversion has many steps, wrapped behind one method:
  class MediaConverter {
    convert(file) {
      const raw = this.decoder.decode(file);
      const small = this.resizer.resize(raw);
      const out = this.encoder.encode(small);
      return this.uploader.upload(out);
    }
  }
  media.convert("clip.mov");  // the client need not know the 4 steps

Benefit: reduces coupling between the client and the subsystem, is
easy to use, and easy to change internally. Unlike Adapter (which
changes an interface for compatibility), a Facade simply
simplifies.',
'[]',20,1780),

('n_dp_proxy','Proxy','Architecture',
'Proxy đứng THAY cho object thật để kiểm soát truy cập: lazy load,
cache, kiểm tra quyền, logging — cùng interface với object thật.

Ví dụ (JS Proxy chặn truy cập trường nhạy cảm):
  const safeUser = new Proxy(user, {
    get(obj, key) {
      if (key === "ssn") throw new Error("Cấm truy cập");
      return obj[key];
    }
  });

Các biến thể:
  • Virtual proxy : trì hoãn tạo object nặng tới khi cần (lazy).
  • Protection    : kiểm tra quyền trước khi cho gọi.
  • Remote        : gọi service từ xa nhưng trông như gọi local.

Khác Decorator (thêm hành vi), Proxy tập trung KIỂM SOÁT truy cập.',
'A Proxy stands IN FOR the real object to control access: lazy
loading, caching, permission checks, logging - with the same
interface as the real object.

Example (a JS Proxy blocking access to a sensitive field):
  const safeUser = new Proxy(user, {
    get(obj, key) {
      if (key === "ssn") throw new Error("Access denied");
      return obj[key];
    }
  });

Variants:
  • Virtual proxy : defer creating a heavy object until needed (lazy).
  • Protection    : check permissions before allowing a call.
  • Remote        : call a remote service as if it were local.

Unlike Decorator (which adds behavior), a Proxy focuses on
CONTROLLING access.',
'[]',100,1780),

-- ===== Section 4: Behavioral =====
('n_dp_strategy','Strategy','Architecture',
'Strategy đóng gói nhiều THUẬT TOÁN có thể thay thế nhau, chọn lúc
chạy -> loại bỏ khối if/else lớn và tuân Open/Closed.

Ví dụ (phí vận chuyển theo hãng):
  const strategies = {
    fedex: order => order.weight * 2.0,
    ups:   order => order.weight * 1.8,
    self:  order => 0,
  };
  function shippingCost(order, carrier) {
    return strategies[carrier](order);
  }

Thêm hãng mới = thêm MỘT hàm, KHÔNG sửa chỗ gọi. Đây là cách khử
if/else phình to theo loại.

Rất phổ biến: cách tính giá, thuật toán nén, chiến lược retry.',
'Strategy encapsulates several interchangeable ALGORITHMS chosen at
runtime -> removes big if/else blocks and follows Open/Closed.

Example (shipping cost per carrier):
  const strategies = {
    fedex: order => order.weight * 2.0,
    ups:   order => order.weight * 1.8,
    self:  order => 0,
  };
  function shippingCost(order, carrier) {
    return strategies[carrier](order);
  }

Adding a new carrier = adding ONE function, NO change to the caller.
This is how you eliminate if/else that grows with each type.

Very common: pricing, compression algorithms, retry strategies.',
'[]',220,1720),

('n_dp_observer','Observer','Architecture',
'Observer: khi một đối tượng (subject) đổi trạng thái, nó tự động
THÔNG BÁO mọi observer đã đăng ký. Đây là nền của lập trình
event-driven.

Ví dụ (EventEmitter của Node):
  const { EventEmitter } = require("events");
  const bus = new EventEmitter();
  bus.on("userRegistered", user => sendWelcomeEmail(user));
  bus.on("userRegistered", user => createAuditLog(user));
  bus.emit("userRegistered", newUser);  // CẢ HAI observer chạy

Lợi ích: subject không cần biết ai đang nghe -> giảm ghép nối, dễ
thêm phản ứng mới.

Xuất hiện khắp nơi: EventEmitter, RxJS (Observable), hệ reactivity
của Vue, DOM addEventListener.',
'Observer: when a subject changes state, it automatically NOTIFIES
all registered observers. This is the basis of event-driven
programming.

Example (Node EventEmitter):
  const { EventEmitter } = require("events");
  const bus = new EventEmitter();
  bus.on("userRegistered", user => sendWelcomeEmail(user));
  bus.on("userRegistered", user => createAuditLog(user));
  bus.emit("userRegistered", newUser);  // BOTH observers run

Benefit: the subject need not know who is listening -> less
coupling, easy to add new reactions.

It appears everywhere: EventEmitter, RxJS (Observable), the Vue
reactivity system, DOM addEventListener.',
'[]',300,1720),

('n_dp_command','Command','Architecture',
'Command đóng gói một YÊU CẦU thành object -> cho phép xếp hàng
(queue), hoàn tác (undo), ghi log, và thử lại (retry).

Ví dụ (thêm/hoàn tác vào giỏ hàng):
  class AddItemCommand {
    constructor(cart, item) { this.cart = cart; this.item = item; }
    execute() { this.cart.add(this.item); }
    undo()    { this.cart.remove(this.item); }
  }
  const history = [];
  function run(cmd) { cmd.execute(); history.push(cmd); }
  function undoLast() { history.pop()?.undo(); }

Vì mỗi hành động là một object, ta lưu lịch sử để undo/redo, đẩy
vào hàng đợi job, hoặc serialize để chạy sau.

Hợp cho: job queue, undo/redo (editor), transaction script.',
'Command encapsulates a REQUEST as an object -> enabling queuing,
undo, logging, and retry.

Example (add/undo on a shopping cart):
  class AddItemCommand {
    constructor(cart, item) { this.cart = cart; this.item = item; }
    execute() { this.cart.add(this.item); }
    undo()    { this.cart.remove(this.item); }
  }
  const history = [];
  function run(cmd) { cmd.execute(); history.push(cmd); }
  function undoLast() { history.pop()?.undo(); }

Because each action is an object, you can keep a history for
undo/redo, push it into a job queue, or serialize it to run later.

Good for: job queues, undo/redo (editors), transaction scripts.',
'[]',300,1780)
ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ------------------------- EDGES -----------------------------------
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_dp_part-of','root','t_dp','part-of'),
('e_t_dp_s_dp_1_part-of','t_dp','s_dp_1','part-of'),
('e_t_dp_s_dp_2_part-of','t_dp','s_dp_2','part-of'),
('e_t_dp_s_dp_3_part-of','t_dp','s_dp_3','part-of'),
('e_t_dp_s_dp_4_part-of','t_dp','s_dp_4','part-of'),
('e_s_dp_1_n_dp_intro','s_dp_1','n_dp_intro','part-of'),
('e_s_dp_1_n_dp_solid','s_dp_1','n_dp_solid','part-of'),
('e_s_dp_1_n_dp_backend','s_dp_1','n_dp_backend','part-of'),
('e_s_dp_2_n_dp_singleton','s_dp_2','n_dp_singleton','part-of'),
('e_s_dp_2_n_dp_factory','s_dp_2','n_dp_factory','part-of'),
('e_s_dp_2_n_dp_builder','s_dp_2','n_dp_builder','part-of'),
('e_s_dp_3_n_dp_adapter','s_dp_3','n_dp_adapter','part-of'),
('e_s_dp_3_n_dp_decorator','s_dp_3','n_dp_decorator','part-of'),
('e_s_dp_3_n_dp_facade','s_dp_3','n_dp_facade','part-of'),
('e_s_dp_3_n_dp_proxy','s_dp_3','n_dp_proxy','part-of'),
('e_s_dp_4_n_dp_strategy','s_dp_4','n_dp_strategy','part-of'),
('e_s_dp_4_n_dp_observer','s_dp_4','n_dp_observer','part-of'),
('e_s_dp_4_n_dp_command','s_dp_4','n_dp_command','part-of'),
('e_n_dp_observer_n_ee_basic_rel','n_dp_observer','n_ee_basic','related'),
('e_n_dp_decorator_q_38_rel','n_dp_decorator','q_38','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);


-- ===== TOPIC: Microservices (xem seed_microservices.sql) =====
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_ms','Microservices','System Design',
'Kiến trúc microservices: khái niệm & ranh giới (DDD), giao tiếp sync/async, API gateway, nhất quán dữ liệu phân tán (Saga, CQRS, Outbox), service discovery, resiliency và observability.',
'Microservices architecture: concepts & boundaries (DDD), sync/async communication, API gateway, distributed data consistency (Saga, CQRS, Outbox), service discovery, resiliency, and observability.',
'[]',1800,1650),

('s_ms_1','Khái niệm & Kiến trúc','System Design',
'Monolith vs microservices, chia ranh giới theo nghiệp vụ (DDD), database per service.',
'Monolith vs microservices, splitting by business boundaries (DDD), database per service.',
'[]',1720,1550),
('s_ms_2','Giao tiếp giữa service','System Design',
'Giao tiếp đồng bộ (REST/gRPC), bất đồng bộ (message/event) và API gateway.',
'Synchronous (REST/gRPC), asynchronous (message/event) communication, and the API gateway.',
'[]',1900,1550),
('s_ms_3','Dữ liệu & Nhất quán','System Design',
'Xử lý nhất quán phân tán: Saga, CQRS, Transactional Outbox.',
'Handling distributed consistency: Saga, CQRS, Transactional Outbox.',
'[]',1720,1780),
('s_ms_4','Vận hành & Resiliency','System Design',
'Service discovery, chống lỗi (circuit breaker/retry) và observability.',
'Service discovery, resiliency (circuit breaker/retry), and observability.',
'[]',1900,1780),

-- ===== Section 1 =====
('n_ms_intro','Monolith vs Microservices','System Design',
'Microservices = chia hệ thống thành nhiều service NHỎ, độc lập,
mỗi service phụ trách một nghiệp vụ và triển khai riêng.

  Monolith       : 1 codebase, 1 deploy, 1 DB dùng chung
  Microservices  : nhiều service, deploy độc lập, DB riêng mỗi service

Ưu điểm: mở rộng độc lập theo service, đội nhóm tự chủ, cô lập lỗi,
tự do chọn công nghệ theo service.

Nhược điểm: phức tạp vận hành (deploy, mạng, monitoring), độ trễ
mạng, nhất quán dữ liệu khó, cần DevOps/CI-CD mạnh.

Lời khuyên: đừng bắt đầu bằng microservices. Hãy làm một MODULAR
MONOLITH tốt trước, chỉ tách service khi có lý do rõ ràng (quy mô,
số đội nhóm, nhịp deploy khác nhau).',
'Microservices = splitting a system into many SMALL, independent
services, each owning one business capability and deployed
separately.

  Monolith       : 1 codebase, 1 deploy, 1 shared DB
  Microservices  : many services, independent deploys, a DB per service

Pros: independent scaling per service, autonomous teams, fault
isolation, freedom to pick tech per service.

Cons: operational complexity (deploy, network, monitoring), network
latency, hard data consistency, needs strong DevOps/CI-CD.

Advice: do not start with microservices. Build a good MODULAR
MONOLITH first, and split into services only for clear reasons
(scale, number of teams, differing deploy cadence).',
'[]',1680,1490),

('n_ms_boundaries','Ranh giới service (DDD)','System Design',
'Ranh giới service nên theo NGHIỆP VỤ (business capability), KHÔNG
theo tầng kỹ thuật. Domain-Driven Design gọi mỗi vùng là một
bounded context.

  ✓ ĐÚNG : Order Service, Payment Service, Inventory Service
  ✗ SAI  : Controller Service, Database Service (chia theo kỹ thuật)

Mỗi service phải TỰ CHỨA dữ liệu + logic của miền đó và chỉ giao
tiếp qua API/hợp đồng rõ ràng.

Chia sai ranh giới -> các service phụ thuộc chằng chịt, phải deploy
cùng nhau -> "distributed monolith": mang mọi cái khó của phân tán
mà không có lợi ích độc lập. Đây là sai lầm phổ biến nhất.',
'Service boundaries should follow BUSINESS capabilities, NOT
technical layers. Domain-Driven Design calls each area a bounded
context.

  ✓ RIGHT : Order Service, Payment Service, Inventory Service
  ✗ WRONG : Controller Service, Database Service (split by tech)

Each service must be SELF-CONTAINED with its domain data + logic and
communicate only via clear APIs/contracts.

Wrong boundaries -> tightly entangled services that must deploy
together -> a "distributed monolith": all the pain of distribution
with none of the independence benefits. This is the most common
mistake.',
'[]',1760,1490),

('n_ms_db_per_service','Database per Service','System Design',
'Mỗi service SỞ HỮU database riêng; service khác KHÔNG được truy cập
trực tiếp DB đó -> chỉ qua API của service chủ. Giữ tính độc lập và
đóng gói.

  Order Service    -> orders_db
  Payment Service  -> payments_db
  Inventory Service-> inventory_db

HỆ QUẢ quan trọng:
  • Không JOIN xuyên service -> muốn dữ liệu tổng hợp phải gọi API
    hoặc giữ một bản sao (read model / data replication).
  • Không có transaction ACID xuyên nhiều DB -> cần Saga cho quy
    trình nghiệp vụ trải nhiều service.

Đánh đổi độc lập lấy sự phức tạp về dữ liệu — đây là gốc rễ của hầu
hết thách thức trong microservices.',
'Each service OWNS its own database; other services must NOT access
that DB directly -> only through the owning service API. This keeps
independence and encapsulation.

  Order Service     -> orders_db
  Payment Service   -> payments_db
  Inventory Service -> inventory_db

Key CONSEQUENCES:
  • No cross-service JOINs -> to get combined data you call an API
    or keep a copy (a read model / data replication).
  • No ACID transaction across multiple DBs -> you need a Saga for a
    business process spanning several services.

You trade independence for data complexity - this is the root of
most microservices challenges.',
'[]',1680,1610),

-- ===== Section 2: Communication =====
('n_ms_sync','Giao tiếp đồng bộ (REST / gRPC)','System Design',
'Service gọi trực tiếp một service khác và CHỜ phản hồi.

  REST/HTTP : phổ biến, dễ, JSON; hợp API công khai và đa số nội bộ.
  gRPC      : nhị phân (protobuf), nhanh + gọn, có streaming; hợp
              giao tiếp nội bộ service-to-service hiệu năng cao.

Nhược điểm cốt lõi: TEMPORAL COUPLING (ghép nối thời gian) — service
đích phải đang sống thì lời gọi mới thành công. Một service chậm/sập
có thể kéo theo dây chuyền.

Vì vậy giao tiếp sync PHẢI đi kèm: timeout, retry + backoff, và
circuit breaker (xem node Resiliency).

Dùng khi: cần phản hồi ngay lập tức (truy vấn dữ liệu, xác thực).',
'A service calls another directly and WAITS for the response.

  REST/HTTP : popular, easy, JSON; good for public APIs and most
              internal calls.
  gRPC      : binary (protobuf), fast + compact, supports streaming;
              good for high-performance internal service-to-service.

The core drawback: TEMPORAL COUPLING - the target service must be
alive for the call to succeed. One slow/down service can cascade.

So synchronous calls MUST include: timeouts, retry + backoff, and a
circuit breaker (see the Resiliency node).

Use when: you need an immediate response (data queries, auth).',
'[]',1860,1490),

('n_ms_async','Giao tiếp bất đồng bộ (Message / Event)','System Design',
'Service giao tiếp qua MESSAGE BROKER, không chờ nhau trực tiếp ->
giảm ghép nối, chịu lỗi tốt hơn.

  Producer ─► [ Broker: Kafka / RabbitMQ / SQS ] ─► Consumer(s)

Hai kiểu:
  • Message queue (điểm-điểm): mỗi message tới ĐÚNG một consumer
    (giao việc, xử lý nền — vd gửi email, resize ảnh).
  • Pub/Sub event: một event, NHIỀU service cùng phản ứng (vd
    "OrderPlaced" -> Inventory, Email, Analytics đều nghe).

Ưu: service đích tạm sập vẫn nhận message sau (broker giữ lại);
tách rời -> dễ thêm consumer mới.

Nhược: nhất quán cuối cùng (eventual), khó lần theo luồng, cần xử lý
message trùng (idempotent). Nền của event-driven architecture.',
'Services communicate through a MESSAGE BROKER, not directly waiting
on each other -> less coupling, better fault tolerance.

  Producer ─► [ Broker: Kafka / RabbitMQ / SQS ] ─► Consumer(s)

Two styles:
  • Message queue (point-to-point): each message goes to EXACTLY one
    consumer (task handoff, background work - e.g. send email, resize
    image).
  • Pub/Sub event: one event, MANY services react (e.g. "OrderPlaced"
    -> Inventory, Email, Analytics all listen).

Pros: a down target still receives messages later (the broker keeps
them); decoupled -> easy to add new consumers.

Cons: eventual consistency, harder to trace flows, must handle
duplicate messages (be idempotent). The basis of event-driven
architecture.',
'[]',1940,1490),

('n_ms_gateway','API Gateway','System Design',
'API Gateway là CỬA VÀO duy nhất cho client bên ngoài, đứng trước
các microservice.

  Client ─► API Gateway ─► (routing) ─► Order / Payment / User ...

Nhiệm vụ tập trung một chỗ:
  • Định tuyến request tới đúng service
  • Xác thực & ủy quyền (kiểm JWT một lần)
  • Rate limiting, TLS termination
  • Aggregation: gộp nhiều service thành 1 phản hồi cho client
  • Che giấu cấu trúc nội bộ (client không gọi thẳng từng service)

Ví dụ: Kong, NGINX, AWS API Gateway. Với BFF (Backend For Frontend)
mỗi loại client có gateway riêng.

Cẩn thận: đừng nhồi business logic vào gateway -> dễ thành điểm
nghẽn và "God object".',
'An API Gateway is the single ENTRY POINT for external clients,
sitting in front of the microservices.

  Client ─► API Gateway ─► (routing) ─► Order / Payment / User ...

Responsibilities centralized in one place:
  • Route requests to the right service
  • Authentication & authorization (verify JWT once)
  • Rate limiting, TLS termination
  • Aggregation: combine several services into one client response
  • Hide the internal structure (clients do not call services directly)

Examples: Kong, NGINX, AWS API Gateway. With BFF (Backend For
Frontend), each client type gets its own gateway.

Caution: do not stuff business logic into the gateway -> it easily
becomes a bottleneck and a "God object".',
'[]',1860,1610),

-- ===== Section 3: Data & Consistency =====
('n_ms_saga','Saga — nhất quán phân tán','System Design',
'Vì không có transaction ACID xuyên nhiều DB service, Saga = một
CHUỖI transaction cục bộ; mỗi bước phát event kích hoạt bước kế.
Nếu một bước LỖI -> chạy các bước BÙ TRỪ (compensating) để hoàn tác
các bước trước.

SƠ ĐỒ (quy trình đặt hàng):

  Order created
    │
    ├─► Payment: charge      ── lỗi ─► Cancel Order        (bù)
    │
    ├─► Inventory: reserve   ── lỗi ─► Refund Payment       (bù)
    │
    └─► Shipping: create     ── lỗi ─► Release Inventory    (bù)

Hai kiểu điều phối:
  • Choreography : mỗi service tự lắng nghe event của service khác,
    KHÔNG có bộ điều khiển trung tâm (đơn giản, dễ rối khi nhiều bước).
  • Orchestration: một orchestrator điều khiển trình tự (dễ theo dõi,
    tập trung hơn).

Đánh đổi: chỉ đạt nhất quán CUỐI CÙNG; phải thiết kế cẩn thận bước bù
và xử lý lỗi bù.',
'Because there is no ACID transaction across multiple service DBs, a
Saga = a SEQUENCE of local transactions; each step emits an event
triggering the next. If a step FAILS -> run COMPENSATING steps to
undo the previous ones.

DIAGRAM (order placement):

  Order created
    │
    ├─► Payment: charge      ── fail ─► Cancel Order         (compensate)
    │
    ├─► Inventory: reserve   ── fail ─► Refund Payment        (compensate)
    │
    └─► Shipping: create     ── fail ─► Release Inventory     (compensate)

Two coordination styles:
  • Choreography : each service listens to others events, with NO
    central controller (simple, but tangled with many steps).
  • Orchestration: a single orchestrator drives the sequence (easier
    to follow, more centralized).

Trade-off: only EVENTUAL consistency; you must carefully design
compensating steps and handle compensation failures.',
'[]',1680,1720),

('n_ms_cqrs','CQRS','System Design',
'CQRS (Command Query Responsibility Segregation): tách mô hình GHI
(command) khỏi mô hình ĐỌC (query).

  Ghi (Command) : mô hình chuẩn hóa, đảm bảo bất biến nghiệp vụ.
  Đọc (Query)   : mô hình phi chuẩn hóa, tối ưu cho truy vấn hiển
                  thị (read model), có thể ở DB/khoản mục khác.

Thường đi kèm event: khi ghi thành công -> phát event -> cập nhật
read model (bất đồng bộ).

  [Command] -> write DB -> event -> cập nhật -> [Read model] -> [Query]

Hợp khi: tỉ lệ đọc >> ghi, hoặc mô hình đọc và ghi khác nhau nhiều.

Nhược: phức tạp thêm, và read model trễ so với write (eventual
consistency). Đừng dùng CQRS cho CRUD đơn giản.',
'CQRS (Command Query Responsibility Segregation): separate the WRITE
model (command) from the READ model (query).

  Write (Command) : a normalized model enforcing business invariants.
  Read (Query)    : a denormalized model optimized for display
                    queries (a read model), possibly in a different DB.

Often paired with events: on a successful write -> emit an event ->
update the read model (asynchronously).

  [Command] -> write DB -> event -> update -> [Read model] -> [Query]

Use when: reads >> writes, or the read and write models differ a lot.

Cons: added complexity, and the read model lags the write (eventual
consistency). Do not use CQRS for simple CRUD.',
'[]',1760,1720),

('n_ms_outbox','Transactional Outbox','System Design',
'Vấn đề "dual write": một thao tác cần GHI DB và PHÁT message. Nếu
ghi DB xong rồi gửi message bị lỗi (hoặc ngược lại) -> hai bên lệch
nhau, mất event.

Giải pháp Outbox: ghi bản ghi nghiệp vụ VÀ một dòng "outbox" trong
CÙNG một transaction DB (nguyên tử). Một tiến trình relay đọc bảng
outbox rồi phát message, đánh dấu đã gửi.

  BEGIN;
    INSERT INTO orders (...);
    INSERT INTO outbox (event_type, payload);   -- cùng transaction
  COMMIT;
  -- relay: đọc outbox chưa gửi -> publish lên broker -> đánh dấu sent

Đảm bảo giao ÍT NHẤT MỘT LẦN (at-least-once) -> consumer PHẢI
idempotent (xử lý trùng không gây hại). Là cách chuẩn để ghép DB và
messaging đáng tin cậy.',
'The "dual write" problem: an operation must WRITE to the DB and
PUBLISH a message. If the DB write succeeds but the publish fails
(or vice versa) -> the two diverge and events are lost.

Outbox solution: write the business record AND an "outbox" row in
the SAME DB transaction (atomic). A relay process reads the outbox
table, publishes the message, then marks it sent.

  BEGIN;
    INSERT INTO orders (...);
    INSERT INTO outbox (event_type, payload);   -- same transaction
  COMMIT;
  -- relay: read unsent outbox -> publish to the broker -> mark sent

It guarantees AT-LEAST-ONCE delivery -> consumers MUST be idempotent
(handling duplicates does no harm). This is the standard way to
combine DB writes and messaging reliably.',
'[]',1680,1780),

-- ===== Section 4: Operations & Resiliency =====
('n_ms_discovery','Service Discovery','System Design',
'Service scale động, container lên/xuống liên tục -> IP thay đổi ->
cần cơ chế tìm địa chỉ hiện tại của một service.

  • Client-side discovery : client hỏi một registry (Consul, Eureka)
    lấy danh sách instance rồi tự chọn (client tự cân bằng tải).
  • Server-side discovery  : client gọi một địa chỉ ổn định; load
    balancer/DNS định tuyến tới instance (vd Kubernetes Service).

Trong Kubernetes: mỗi service có DNS nội bộ ổn định
(order-svc.namespace.svc) + cân bằng tải tích hợp -> thường KHÔNG
cần registry riêng.

Đi kèm health check: chỉ định tuyến tới instance đang khỏe.',
'Services scale dynamically, containers come and go -> IPs change ->
you need a way to find a service current address.

  • Client-side discovery : the client queries a registry (Consul,
    Eureka) for the instance list and picks one (client load-balances).
  • Server-side discovery  : the client calls a stable address; a
    load balancer/DNS routes to an instance (e.g. Kubernetes Service).

In Kubernetes: each service has a stable internal DNS name
(order-svc.namespace.svc) + built-in load balancing -> usually NO
separate registry needed.

Pair it with health checks: route only to healthy instances.',
'[]',1860,1720),

('n_ms_circuit','Resiliency: Circuit Breaker, Retry, Timeout','System Design',
'Trong hệ phân tán, lỗi mạng là BÌNH THƯỜNG -> phải chống lỗi lan
truyền (cascading failure) làm sập cả hệ.

  • Timeout        : luôn đặt; đừng chờ vô hạn một service chậm.
  • Retry + backoff: thử lại với độ trễ TĂNG DẦN + jitter (cẩn thận
    retry storm làm ngập service đang yếu).
  • Circuit breaker: khi service đích lỗi liên tục -> "mở mạch", trả
    lỗi/nhanh fallback một thời gian thay vì cứ gọi -> cho đích hồi
    phục. Trạng thái:
        closed (gọi bình thường) -> open (chặn, trả lỗi ngay)
        -> half-open (thử vài lời gọi) -> closed nếu ổn
  • Bulkhead       : cô lập tài nguyên (pool riêng) để một phần lỗi
    không kéo sập toàn bộ.

Thư viện: opossum (Node.js), resilience4j (Java).',
'In a distributed system, network failures are NORMAL -> you must
prevent cascading failures from taking down the whole system.

  • Timeout        : always set one; never wait forever on a slow
    service.
  • Retry + backoff: retry with INCREASING delay + jitter (beware a
    retry storm flooding an already weak service).
  • Circuit breaker: when a target keeps failing -> "open the
    circuit", return a fast error/fallback for a while instead of
    calling -> let the target recover. States:
        closed (normal calls) -> open (blocked, fail fast)
        -> half-open (try a few calls) -> closed if healthy
  • Bulkhead       : isolate resources (separate pools) so one
    failing part does not sink everything.

Libraries: opossum (Node.js), resilience4j (Java).',
'[]',1940,1720),

('n_ms_observability','Observability','System Design',
'Với nhiều service, một request đi qua nhiều nơi -> rất khó lần theo
khi có sự cố. Observability đứng trên 3 trụ cột:

  • Logs    : log có CẤU TRÚC (JSON) + correlation id xuyên service
    để nối các dòng log của cùng một request.
  • Metrics : số liệu định lượng (Prometheus) -> dashboard (Grafana),
    cảnh báo (alert) khi vượt ngưỡng.
  • Tracing : distributed tracing (OpenTelemetry, Jaeger) — theo dõi
    MỘT request qua tất cả service, thấy từng chặng tốn bao lâu.

SƠ ĐỒ trace:
  request ─trace-id=abc─► Gateway ─► Order ─► Payment ─► DB
           (mỗi chặng là 1 span, cùng trace-id)

Truyền trace id qua header giữa các service (context propagation).
Thiếu observability = vận hành microservices trong bóng tối.',
'With many services, one request passes through many places -> very
hard to trace during an incident. Observability rests on 3 pillars:

  • Logs    : STRUCTURED logs (JSON) + a correlation id across
    services to stitch together the log lines of one request.
  • Metrics : quantitative measurements (Prometheus) -> dashboards
    (Grafana), alerts when thresholds are crossed.
  • Tracing : distributed tracing (OpenTelemetry, Jaeger) - follow
    ONE request across all services, seeing how long each hop takes.

Trace DIAGRAM:
  request ─trace-id=abc─► Gateway ─► Order ─► Payment ─► DB
           (each hop is a span, same trace-id)

Propagate the trace id via headers between services (context
propagation). Without observability you operate microservices in the
dark.',
'[]',1860,1780)
ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ------------------------- EDGES -----------------------------------
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_ms_part-of','root','t_ms','part-of'),
('e_t_ms_s_ms_1_part-of','t_ms','s_ms_1','part-of'),
('e_t_ms_s_ms_2_part-of','t_ms','s_ms_2','part-of'),
('e_t_ms_s_ms_3_part-of','t_ms','s_ms_3','part-of'),
('e_t_ms_s_ms_4_part-of','t_ms','s_ms_4','part-of'),
('e_s_ms_1_n_ms_intro','s_ms_1','n_ms_intro','part-of'),
('e_s_ms_1_n_ms_boundaries','s_ms_1','n_ms_boundaries','part-of'),
('e_s_ms_1_n_ms_db_per_service','s_ms_1','n_ms_db_per_service','part-of'),
('e_s_ms_2_n_ms_sync','s_ms_2','n_ms_sync','part-of'),
('e_s_ms_2_n_ms_async','s_ms_2','n_ms_async','part-of'),
('e_s_ms_2_n_ms_gateway','s_ms_2','n_ms_gateway','part-of'),
('e_s_ms_3_n_ms_saga','s_ms_3','n_ms_saga','part-of'),
('e_s_ms_3_n_ms_cqrs','s_ms_3','n_ms_cqrs','part-of'),
('e_s_ms_3_n_ms_outbox','s_ms_3','n_ms_outbox','part-of'),
('e_s_ms_4_n_ms_discovery','s_ms_4','n_ms_discovery','part-of'),
('e_s_ms_4_n_ms_circuit','s_ms_4','n_ms_circuit','part-of'),
('e_s_ms_4_n_ms_observability','s_ms_4','n_ms_observability','part-of'),
('e_n_ms_db_per_service_n_ms_saga_rel','n_ms_db_per_service','n_ms_saga','related'),
('e_n_ms_async_n_ms_outbox_rel','n_ms_async','n_ms_outbox','related'),
('e_t_ms_q_43_related','t_ms','q_43','related'),
('e_t_ms_q_10_related','t_ms','q_10','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);


-- ===== TOPIC: React Core (xem seed_react.sql) =====
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_reactc','React Core','Frontend',
'Kiến thức chuyên sâu về React: Virtual DOM & cơ chế render, hooks, quản lý state & dữ liệu, hiệu năng và các mẫu tổ chức component. Bổ trợ cho topic React (Q&A phỏng vấn).',
'In-depth React: Virtual DOM & rendering, hooks, state & data management, performance, and component patterns. Complements the React interview Q&A topic.',
'[]',120,100),

('s_rc_1','Render & Virtual DOM','Frontend',
'Virtual DOM, reconciliation, khi nào component re-render, và vai trò của key.',
'Virtual DOM, reconciliation, when a component re-renders, and the role of keys.',
'[]',40,60),
('s_rc_2','Hooks','Frontend',
'useState, useEffect, useMemo/useCallback và quy tắc hooks + custom hook.',
'useState, useEffect, useMemo/useCallback, and the rules of hooks + custom hooks.',
'[]',220,60),
('s_rc_3','State & Data','Frontend',
'Chọn nơi lưu state, Context, và quản lý dữ liệu server.',
'Choosing where state lives, Context, and server data management.',
'[]',40,220),
('s_rc_4','Hiệu năng & Nâng cao','Frontend',
'Tối ưu re-render, Fiber & concurrent, và các mẫu tổ chức component.',
'Optimizing re-renders, Fiber & concurrent features, and component patterns.',
'[]',220,220),

-- ===== Section 1 =====
('n_rc_vdom','Virtual DOM & Reconciliation','Frontend',
'Virtual DOM (VDOM) là một cây object JS mô tả UI. Khi state đổi,
React tạo VDOM MỚI, SO SÁNH (diffing) với cây cũ, rồi chỉ cập nhật
đúng phần DOM thật thay đổi -> tránh thao tác DOM tốn kém.

SƠ ĐỒ:
  state/props đổi
    ▼
  render() -> VDOM mới
    ▼
  reconciliation (so cây mới với cây cũ)
    ▼
  tính patch tối thiểu -> cập nhật DOM thật

Quy tắc diffing:
  • Cùng type element -> giữ node, chỉ cập nhật thuộc tính đổi.
  • Khác type -> hủy node cũ, tạo mới hoàn toàn.
  • Danh sách -> dùng "key" để nhận diện phần tử (xem node Keys).

Nhờ VDOM, ta viết UI khai báo theo state, React lo phần cập nhật DOM.',
'The Virtual DOM (VDOM) is a JS object tree describing the UI. When
state changes, React builds a NEW VDOM, DIFFS it against the old
tree, then updates only the real DOM parts that changed -> avoiding
expensive DOM operations.

DIAGRAM:
  state/props change
    ▼
  render() -> new VDOM
    ▼
  reconciliation (compare new tree with old)
    ▼
  compute the minimal patch -> update the real DOM

Diffing rules:
  • Same element type -> keep the node, update only changed props.
  • Different type -> destroy the old node, create a brand-new one.
  • Lists -> use a "key" to identify elements (see the Keys node).

Thanks to the VDOM, you write UI declaratively from state and React
handles the DOM updates.',
'[]',20,20),

('n_rc_render','Khi nào component re-render','Frontend',
'Một component re-render khi: state của nó đổi (useState/useReducer),
props đổi, hoặc COMPONENT CHA re-render.

Render chia 2 pha:
  • Render phase : gọi function component để tính VDOM. PHẢI thuần
    (không side effect), có thể bị React chạy lại/hủy.
  • Commit phase : áp thay đổi vào DOM thật, rồi chạy useEffect.

Điểm hay nhầm:
  • Cha render -> mọi con render theo, DÙ props không đổi — trừ khi
    bọc React.memo.
  • Re-render KHÁC cập nhật DOM: nếu VDOM không đổi thì DOM không bị
    chạm, nên re-render không phải lúc nào cũng đắt.

  setCount(c => c + 1);  // dùng dạng hàm khi phụ thuộc giá trị cũ
  // setState là bất đồng bộ + gộp (batching), state không đổi ngay',
'A component re-renders when: its own state changes (useState/
useReducer), its props change, or its PARENT re-renders.

Rendering has 2 phases:
  • Render phase : call the function component to compute the VDOM.
    It MUST be pure (no side effects); React may re-run/abort it.
  • Commit phase : apply changes to the real DOM, then run useEffect.

Common confusions:
  • A parent re-render -> all children re-render too, EVEN if props
    did not change - unless wrapped in React.memo.
  • Re-render is NOT the same as a DOM update: if the VDOM is
    unchanged the DOM is untouched, so a re-render is not always
    expensive.

  setCount(c => c + 1);  // use the function form when it depends on
                         // the previous value
  // setState is async + batched, so state does not change immediately',
'[]',100,20),

('n_rc_keys','Keys trong danh sách','Frontend',
'key giúp React nhận diện phần tử nào trong một danh sách đã được
thêm/xóa/đổi chỗ -> tái dùng đúng DOM node và state của mỗi item.

  {items.map(it => <Row key={it.id} data={it} />)}

Quy tắc:
  • Dùng id ỔN ĐỊNH & duy nhất làm key.
  • TRÁNH dùng index của mảng làm key khi danh sách có thể sắp xếp,
    chèn, hoặc xóa -> gây bug: state/DOM bị gán nhầm sang item khác.

Ví dụ lỗi kinh điển: dùng index -> xóa item đầu làm ô input của các
item còn lại hiển thị sai giá trị.

key chỉ cần duy nhất trong CÙNG một danh sách anh em, không cần
toàn cục.',
'A key lets React identify which element in a list was added,
removed, or reordered -> reusing the correct DOM node and state for
each item.

  {items.map(it => <Row key={it.id} data={it} />)}

Rules:
  • Use a STABLE, unique id as the key.
  • AVOID using the array index as the key when the list can be
    sorted, inserted into, or deleted from -> it causes bugs:
    state/DOM gets assigned to the wrong item.

A classic bug: using the index -> deleting the first item makes the
remaining items input fields show the wrong values.

A key only needs to be unique among SIBLINGS in the same list, not
globally.',
'[]',20,120),

-- ===== Section 2: Hooks =====
('n_rc_usestate','useState','Frontend',
'useState lưu state cục bộ trong một function component.

  const [count, setCount] = useState(0);
  setCount(count + 1);          // đặt giá trị
  setCount(c => c + 1);         // dạng HÀM: dùng khi phụ thuộc giá trị cũ

Điểm quan trọng:
  • setState là BẤT ĐỒNG BỘ và được GỘP (batching) trong một sự kiện
    -> state không cập nhật ngay dòng sau setState.
  • State là IMMUTABLE: tạo object/array MỚI thay vì mutate trực tiếp.
      setUser(u => ({ ...u, name: "A" }));   // đúng
      user.name = "A"; setUser(user);         // sai, React không thấy đổi
  • State khởi tạo nặng -> dùng dạng lazy: useState(() => compute()).',
'useState holds local state in a function component.

  const [count, setCount] = useState(0);
  setCount(count + 1);          // set a value
  setCount(c => c + 1);         // FUNCTION form: use when it depends on
                                // the previous value

Key points:
  • setState is ASYNCHRONOUS and BATCHED within an event -> state does
    not update on the line right after setState.
  • State is IMMUTABLE: create a NEW object/array instead of mutating.
      setUser(u => ({ ...u, name: "A" }));   // correct
      user.name = "A"; setUser(user);         // wrong, React sees no change
  • Expensive initial state -> use the lazy form: useState(() => compute()).',
'[]',200,20),

('n_rc_useeffect','useEffect','Frontend',
'useEffect chạy SIDE EFFECT sau khi render: gọi API, subscribe, timer,
thao tác DOM thủ công.

  useEffect(() => {
    const id = setInterval(tick, 1000);
    return () => clearInterval(id);   // cleanup: khi unmount hoặc deps đổi
  }, [deps]);   // chạy lại khi deps đổi; [] = chỉ chạy 1 lần sau mount

Các bẫy phổ biến:
  • Thiếu dependency -> stale closure (đọc giá trị cũ).
  • deps là object/hàm tạo mới mỗi render -> effect chạy liên tục
    (ổn định bằng useMemo/useCallback).
  • Quên cleanup -> rò rỉ (timer, listener, subscription vẫn sống).

Xu hướng mới: KHÔNG dùng useEffect để đồng bộ dữ liệu server; hãy
dùng thư viện query (xem node Server data).',
'useEffect runs SIDE EFFECTS after render: API calls, subscriptions,
timers, manual DOM work.

  useEffect(() => {
    const id = setInterval(tick, 1000);
    return () => clearInterval(id);   // cleanup: on unmount or when deps change
  }, [deps]);   // re-runs when deps change; [] = run once after mount

Common pitfalls:
  • Missing a dependency -> stale closure (reads old values).
  • deps that are objects/functions created each render -> the effect
    runs constantly (stabilize with useMemo/useCallback).
  • Forgetting cleanup -> leaks (timers, listeners, subscriptions stay
    alive).

Modern guidance: do NOT use useEffect to sync server data; use a
query library instead (see the Server data node).',
'[]',280,20),

('n_rc_usememo_cb','useMemo & useCallback','Frontend',
'useMemo nhớ (memoize) một GIÁ TRỊ tính toán; useCallback nhớ một
HÀM -> tránh tính lại / tạo tham chiếu mới mỗi lần render.

  const sorted  = useMemo(() => expensiveSort(list), [list]);
  const onClick = useCallback(() => doSomething(id), [id]);

KHI NÀO dùng (chỉ khi có lý do):
  • Tính toán thực sự nặng cần cache theo deps.
  • Truyền props xuống component con đã bọc React.memo (giữ tham
    chiếu ổn định để memo có tác dụng).

KHI NÀO KHÔNG:
  • Tính toán rẻ -> memo hóa còn tốn hơn (so sánh deps + bộ nhớ).
  • Bọc mọi thứ "cho chắc" -> code rối, không nhanh hơn.

Nguyên tắc: đo bằng Profiler trước, đừng tối ưu theo cảm giác.',
'useMemo memoizes a computed VALUE; useCallback memoizes a FUNCTION
-> avoiding recomputation / a new reference on every render.

  const sorted  = useMemo(() => expensiveSort(list), [list]);
  const onClick = useCallback(() => doSomething(id), [id]);

WHEN to use (only with a reason):
  • A genuinely heavy computation to cache by deps.
  • Passing props down to a child wrapped in React.memo (keep a
    stable reference so memo actually helps).

WHEN NOT:
  • Cheap computation -> memoizing costs more (comparing deps + memory).
  • Wrapping everything "just in case" -> messy code, no faster.

Principle: measure with the Profiler first; do not optimize by feel.',
'[]',200,120),

('n_rc_rules','Rules of Hooks & Custom Hooks','Frontend',
'Hai quy tắc bắt buộc của hooks:
  1. CHỈ gọi hook ở TOP LEVEL của component/custom hook — KHÔNG trong
     if / vòng lặp / hàm lồng. React dựa vào THỨ TỰ gọi hook giữa các
     lần render để khớp state.
  2. CHỈ gọi hook trong function component hoặc trong custom hook
     (tên bắt đầu bằng "use").

Custom hook = gom LOGIC tái dùng (state + effect) thành một hàm use:

  function useToggle(initial = false) {
    const [on, setOn] = useState(initial);
    const toggle = useCallback(() => setOn(v => !v), []);
    return [on, toggle];
  }
  const [open, toggleOpen] = useToggle();

Vi phạm quy tắc 1 (gọi hook có điều kiện) -> thứ tự hook lệch giữa
các render -> state gán nhầm, lỗi khó hiểu.',
'Two mandatory rules of hooks:
  1. ONLY call hooks at the TOP LEVEL of a component/custom hook - NOT
     inside if / loops / nested functions. React relies on the ORDER
     of hook calls across renders to match state.
  2. ONLY call hooks inside a function component or a custom hook
     (name starting with "use").

A custom hook = bundling reusable LOGIC (state + effects) into a use
function:

  function useToggle(initial = false) {
    const [on, setOn] = useState(initial);
    const toggle = useCallback(() => setOn(v => !v), []);
    return [on, toggle];
  }
  const [open, toggleOpen] = useToggle();

Violating rule 1 (calling hooks conditionally) -> the hook order
shifts between renders -> state is misassigned, causing confusing
bugs.',
'[]',280,120),

-- ===== Section 3: State & Data =====
('n_rc_state_mgmt','Chọn nơi lưu State','Frontend',
'Chọn nơi lưu state theo PHẠM VI dùng, từ gần tới xa:

  • Local (useState)   : state của một component.
  • Lift up + props    : chia sẻ giữa vài component gần nhau.
  • Context            : tránh prop-drilling (theme, user hiện tại) —
                         KHÔNG hợp state đổi liên tục (re-render rộng).
  • Thư viện toàn cục  : Redux Toolkit / Zustand / Jotai cho state
                         client phức tạp, nhiều nơi dùng.
  • Server state       : React Query / SWR cho dữ liệu từ server
                         (KHÁC client state — có cache, refetch, đồng
                         bộ; đừng nhét vào Redux).

Nguyên tắc: giữ state CÀNG GẦN nơi dùng càng tốt; chỉ nâng lên/toàn
cục khi thực sự cần chia sẻ. Tránh mặc định nhét mọi thứ vào Redux.',
'Choose where state lives by its SCOPE, from near to far:

  • Local (useState)   : state for one component.
  • Lift up + props    : shared among a few nearby components.
  • Context            : avoid prop-drilling (theme, current user) -
                         NOT for frequently changing state (wide re-render).
  • Global library     : Redux Toolkit / Zustand / Jotai for complex
                         client state used in many places.
  • Server state       : React Query / SWR for server data (DIFFERENT
                         from client state - has caching, refetch,
                         sync; do not stuff it into Redux).

Principle: keep state AS CLOSE as possible to where it is used; only
lift/globalize when sharing is truly needed. Avoid defaulting
everything into Redux.',
'[]',20,180),

('n_rc_context','Context API','Frontend',
'Context truyền dữ liệu xuyên cây component mà không cần prop-drilling.

  const ThemeCtx = createContext("light");
  <ThemeCtx.Provider value={theme}>
    <App />
  </ThemeCtx.Provider>
  // trong con:
  const theme = useContext(ThemeCtx);

CẢNH BÁO hiệu năng: MỌI consumer sẽ RE-RENDER khi value của provider
đổi. Vì vậy:
  • Đừng đặt state đổi liên tục vào một context lớn.
  • Tách context theo mối quan tâm (ThemeCtx, AuthCtx riêng).
  • Memo hóa value: value={useMemo(() => ({...}), [deps])}.

Lưu ý: Context CHỈ là cơ chế TRUYỀN dữ liệu, KHÔNG phải state manager
(không có tối ưu re-render như Redux/Zustand).',
'Context passes data through the component tree without prop-drilling.

  const ThemeCtx = createContext("light");
  <ThemeCtx.Provider value={theme}>
    <App />
  </ThemeCtx.Provider>
  // in a child:
  const theme = useContext(ThemeCtx);

Performance WARNING: EVERY consumer RE-RENDERS when the provider
value changes. Therefore:
  • Do not put frequently changing state into one large context.
  • Split contexts by concern (separate ThemeCtx, AuthCtx).
  • Memoize the value: value={useMemo(() => ({...}), [deps])}.

Note: Context is ONLY a mechanism to PASS data, NOT a state manager
(it has no re-render optimization like Redux/Zustand).',
'[]',100,180),

('n_rc_data','Quản lý dữ liệu server','Frontend',
'Dữ liệu từ server nên dùng thư viện chuyên (TanStack Query, SWR)
thay vì tự viết useEffect + fetch: chúng tự lo cache, khử trùng lặp
(dedupe), refetch, và trạng thái loading/error.

  const { data, isLoading, error } = useQuery({
    queryKey: ["user", id],
    queryFn: () => fetchUser(id),
  });

Vì sao KHÔNG dùng useEffect thủ công:
  • Dễ dính race condition (phản hồi cũ về sau ghi đè mới).
  • Lặp lại code loading/error/cache ở khắp nơi.
  • Không có cache dùng chung giữa các component.

Server state khác client state: nó là bản SAO của dữ liệu ở server
-> cần đồng bộ, hết hạn, refetch. React 18 + Suspense giúp khai báo
trạng thái tải gọn hơn.',
'Server data should use a dedicated library (TanStack Query, SWR)
instead of hand-written useEffect + fetch: they handle caching,
deduping, refetching, and loading/error states for you.

  const { data, isLoading, error } = useQuery({
    queryKey: ["user", id],
    queryFn: () => fetchUser(id),
  });

Why NOT hand-rolled useEffect:
  • Prone to race conditions (a stale response overwrites a newer one).
  • Repeated loading/error/cache code everywhere.
  • No shared cache across components.

Server state differs from client state: it is a COPY of data on the
server -> it needs sync, expiry, refetch. React 18 + Suspense makes
declaring loading states cleaner.',
'[]',20,240),

-- ===== Section 4: Performance & Advanced =====
('n_rc_perf','Tối ưu re-render','Frontend',
'Giảm render thừa:
  • React.memo(Component) : bỏ render con nếu props KHÔNG đổi (so nông).
  • useMemo / useCallback : giữ props/giá trị truyền xuống ổn định để
    React.memo có tác dụng.
  • Tách component        : cô lập phần hay đổi khỏi phần tĩnh.
  • Ảo hóa danh sách dài  : react-window / virtualization.

Nguyên nhân render thừa hay gặp:
  • Truyền object/hàm INLINE làm props "mới" mỗi lần render.
      <Child style={{color:"red"}} onClick={() => x()} />  // mới mỗi lần
  • Đặt state quá cao khiến cả nhánh lớn render lại.

Quy trình: dùng React DevTools Profiler tìm component render thừa
TRƯỚC, rồi mới tối ưu đúng chỗ. Đừng tối ưu sớm.',
'Reduce wasteful renders:
  • React.memo(Component) : skip a child render if props did NOT change
    (shallow compare).
  • useMemo / useCallback : keep passed-down props/values stable so
    React.memo actually helps.
  • Split components       : isolate the changing part from static parts.
  • Virtualize long lists  : react-window / virtualization.

Common causes of wasteful renders:
  • Passing INLINE objects/functions makes props "new" every render.
      <Child style={{color:"red"}} onClick={() => x()} />  // new each time
  • Placing state too high, re-rendering a large branch.

Process: use the React DevTools Profiler to find wasteful renders
FIRST, then optimize the right spot. Do not optimize prematurely.',
'[]',200,180),

('n_rc_fiber','Fiber & Concurrent Features','Frontend',
'Fiber là kiến trúc reconciler mới (từ React 16): chia công việc
render thành các đơn vị nhỏ có thể TẠM DỪNG, tiếp tục, hoặc bỏ theo
ưu tiên -> render không chặn luồng chính (concurrent).

React 18 mở ra các tính năng concurrent:
  • startTransition : đánh dấu cập nhật ÍT ưu tiên (vd lọc danh sách
    lớn) để giữ input mượt.
      startTransition(() => setQuery(text));
  • useDeferredValue : hoãn một giá trị nặng để UI phản hồi trước.
  • Automatic batching : gộp nhiều setState kể cả trong promise/timeout.

Mục tiêu: giữ ứng dụng PHẢN HỒI ngay cả khi có render nặng, bằng
cách ưu tiên tương tác của người dùng.',
'Fiber is the newer reconciler architecture (since React 16): it
splits render work into small units that can be PAUSED, resumed, or
dropped by priority -> non-blocking rendering (concurrent).

React 18 unlocks concurrent features:
  • startTransition : mark a LOW-priority update (e.g. filtering a big
    list) to keep input smooth.
      startTransition(() => setQuery(text));
  • useDeferredValue : defer a heavy value so the UI responds first.
  • Automatic batching : batch multiple setState even inside a
    promise/timeout.

Goal: keep the app RESPONSIVE even under heavy rendering, by
prioritizing user interactions.',
'[]',280,180),

('n_rc_patterns','Component Patterns','Frontend',
'Các mẫu tổ chức component trong React:

  • Composition (children/slots) : ghép component bằng props.children
    -> linh hoạt hơn kế thừa (React KHÔNG khuyến khích kế thừa).
      <Card><Avatar/><Info/></Card>
  • Custom hooks : tái dùng LOGIC có state (cách hiện đại thay cho HOC
    và render props).
  • HOC (Higher-Order Component) : hàm nhận component, trả component
    mới (vd withAuth(Page)) — nay ít dùng hơn hooks.
  • Render props : truyền một hàm render qua prop để chia sẻ logic.
  • Container / Presentational : tách component logic khỏi component
    hiển thị.

Xu hướng hiện đại: ưu tiên COMPOSITION + CUSTOM HOOKS; HOC/render
props chủ yếu còn trong code cũ hoặc thư viện.',
'Component patterns in React:

  • Composition (children/slots) : compose via props.children -> more
    flexible than inheritance (React does NOT favor inheritance).
      <Card><Avatar/><Info/></Card>
  • Custom hooks : reuse stateful LOGIC (the modern replacement for
    HOCs and render props).
  • HOC (Higher-Order Component) : a function taking a component and
    returning a new one (e.g. withAuth(Page)) - now used less than hooks.
  • Render props : pass a render function via a prop to share logic.
  • Container / Presentational : separate logic components from
    presentational ones.

Modern trend: prefer COMPOSITION + CUSTOM HOOKS; HOC/render props
mostly remain in legacy code or libraries.',
'[]',200,240)
ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ------------------------- EDGES -----------------------------------
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_reactc_part-of','root','t_reactc','part-of'),
('e_t_reactc_t_react_related','t_reactc','t_react','related'),
('e_t_reactc_s_rc_1_part-of','t_reactc','s_rc_1','part-of'),
('e_t_reactc_s_rc_2_part-of','t_reactc','s_rc_2','part-of'),
('e_t_reactc_s_rc_3_part-of','t_reactc','s_rc_3','part-of'),
('e_t_reactc_s_rc_4_part-of','t_reactc','s_rc_4','part-of'),
('e_s_rc_1_n_rc_vdom','s_rc_1','n_rc_vdom','part-of'),
('e_s_rc_1_n_rc_render','s_rc_1','n_rc_render','part-of'),
('e_s_rc_1_n_rc_keys','s_rc_1','n_rc_keys','part-of'),
('e_s_rc_2_n_rc_usestate','s_rc_2','n_rc_usestate','part-of'),
('e_s_rc_2_n_rc_useeffect','s_rc_2','n_rc_useeffect','part-of'),
('e_s_rc_2_n_rc_usememo_cb','s_rc_2','n_rc_usememo_cb','part-of'),
('e_s_rc_2_n_rc_rules','s_rc_2','n_rc_rules','part-of'),
('e_s_rc_3_n_rc_state_mgmt','s_rc_3','n_rc_state_mgmt','part-of'),
('e_s_rc_3_n_rc_context','s_rc_3','n_rc_context','part-of'),
('e_s_rc_3_n_rc_data','s_rc_3','n_rc_data','part-of'),
('e_s_rc_4_n_rc_perf','s_rc_4','n_rc_perf','part-of'),
('e_s_rc_4_n_rc_fiber','s_rc_4','n_rc_fiber','part-of'),
('e_s_rc_4_n_rc_patterns','s_rc_4','n_rc_patterns','part-of'),
('e_n_rc_render_n_rc_perf_rel','n_rc_render','n_rc_perf','related'),
('e_n_rc_data_n_rc_useeffect_rel','n_rc_data','n_rc_useeffect','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);


-- ===== TOPIC: Vue Core (xem seed_vue.sql) =====
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_vue','Vue Core','Frontend',
'Kiến thức chuyên sâu về Vue 3: hệ reactivity (Proxy), computed/watch, vòng đời, Single File Component, Composition API, directive & slot, Pinia, hiệu năng và so sánh với React.',
'In-depth Vue 3: the reactivity system (Proxy), computed/watch, lifecycle, Single File Components, the Composition API, directives & slots, Pinia, performance, and a comparison with React.',
'[]',1800,100),

('s_vue_1','Reactivity','Frontend',
'Cơ chế theo dõi thay đổi (ref/reactive, Proxy), computed vs watch, và vòng đời.',
'The change-tracking mechanism (ref/reactive, Proxy), computed vs watch, and lifecycle.',
'[]',1720,60),
('s_vue_2','Component & Composition','Frontend',
'Single File Component, Composition API vs Options API, và props/emit + v-model.',
'Single File Components, Composition API vs Options API, and props/emit + v-model.',
'[]',1900,60),
('s_vue_3','Template & Directives','Frontend',
'Các directive (v-if/v-for/v-bind/v-on/v-model) và slots.',
'Directives (v-if/v-for/v-bind/v-on/v-model) and slots.',
'[]',1720,220),
('s_vue_4','State & Nâng cao','Frontend',
'Quản lý state với Pinia, tối ưu hiệu năng, và so sánh Vue vs React.',
'State management with Pinia, performance optimization, and Vue vs React.',
'[]',1900,220),

-- ===== Section 1: Reactivity =====
('n_vue_reactivity','Reactivity (ref & reactive)','Frontend',
'Vue 3 theo dõi thay đổi TỰ ĐỘNG nhờ reactivity dựa trên Proxy.

  import { ref, reactive } from "vue";
  const count = ref(0);                 // giá trị đơn -> dùng count.value
  const state = reactive({ items: [] }); // object/array -> dùng trực tiếp
  count.value++;         // Vue tự biết và cập nhật UI liên quan
  state.items.push(1);   // cũng phản ứng

SƠ ĐỒ track/trigger:
  đọc reactive trong render/computed  -> Vue TRACK (ghi nhớ phụ thuộc)
  ghi reactive                        -> Vue TRIGGER -> chạy lại đúng
                                         effect/render phụ thuộc nó

Khác React (phải gọi setState và so sánh VDOM), Vue biết CHÍNH XÁC
cái gì phụ thuộc cái gì -> cập nhật mịn, ít render thừa hơn.

Lưu ý: ref cần .value trong JS (template tự mở); reactive không dùng
được với kiểu nguyên thủy.',
'Vue 3 tracks changes AUTOMATICALLY via Proxy-based reactivity.

  import { ref, reactive } from "vue";
  const count = ref(0);                 // a single value -> use count.value
  const state = reactive({ items: [] }); // object/array -> use directly
  count.value++;         // Vue knows and updates the related UI
  state.items.push(1);   // also reactive

track/trigger DIAGRAM:
  reading reactive in render/computed  -> Vue TRACKS (records the dependency)
  writing reactive                     -> Vue TRIGGERS -> re-runs exactly
                                          the effects/renders that depend on it

Unlike React (which needs setState and VDOM diffing), Vue knows
EXACTLY what depends on what -> fine-grained updates with fewer
wasted renders.

Note: ref needs .value in JS (templates auto-unwrap); reactive does
not work with primitive types.',
'[]',1680,20),

('n_vue_computed','computed vs watch','Frontend',
'computed = giá trị DẪN XUẤT, tự CACHE theo phụ thuộc; watch = chạy
SIDE EFFECT khi nguồn đổi.

  const count = ref(1);
  const double = computed(() => count.value * 2);  // cache, chỉ tính
                                                    // lại khi count đổi
  watch(count, (newV, oldV) => {
    console.log("count đổi:", oldV, "->", newV);     // side effect
  });

Khi nào dùng gì:
  • computed : giá trị hiển thị dẫn xuất từ state (lọc, tính tổng,
    format). Có cache nên hiệu quả.
  • watch    : phản ứng thay đổi bằng hành động (gọi API khi từ khóa
    tìm kiếm đổi, ghi localStorage, điều hướng).

Sai lầm: dùng watch để tính một giá trị rồi gán vào ref khác — hãy
dùng computed (gọn, có cache, ít bug).',
'computed = a DERIVED value that CACHES by its dependencies; watch =
runs a SIDE EFFECT when a source changes.

  const count = ref(1);
  const double = computed(() => count.value * 2);  // cached, recomputes
                                                    // only when count changes
  watch(count, (newV, oldV) => {
    console.log("count changed:", oldV, "->", newV);  // side effect
  });

When to use which:
  • computed : a display value derived from state (filtering, totals,
    formatting). Cached, so efficient.
  • watch    : react to a change with an action (call an API when the
    search term changes, write localStorage, navigate).

Mistake: using watch to compute a value then assign it to another ref
- use computed instead (concise, cached, fewer bugs).',
'[]',1760,20),

('n_vue_lifecycle','Lifecycle hooks','Frontend',
'Vòng đời component (Composition API):

  import { onMounted, onUpdated, onUnmounted } from "vue";
  onMounted(()   => { /* DOM đã gắn -> gọi API, thao tác DOM */ });
  onUpdated(()   => { /* sau khi DOM cập nhật lại */ });
  onUnmounted(() => { /* dọn dẹp: clear timer, gỡ listener */ });

Ví dụ dọn dẹp đúng cách:
  const id = setInterval(tick, 1000);
  onUnmounted(() => clearInterval(id));   // tránh rò rỉ

Các mốc khác: onBeforeMount, onBeforeUpdate, onBeforeUnmount,
onErrorCaptured.

So với React: các hook này tương ứng vai trò của useEffect nhưng
TÁCH RÕ từng mốc vòng đời -> dễ đọc ý định hơn.',
'Component lifecycle (Composition API):

  import { onMounted, onUpdated, onUnmounted } from "vue";
  onMounted(()   => { /* DOM mounted -> call API, DOM work */ });
  onUpdated(()   => { /* after the DOM re-updates */ });
  onUnmounted(() => { /* cleanup: clear timers, remove listeners */ });

Proper cleanup example:
  const id = setInterval(tick, 1000);
  onUnmounted(() => clearInterval(id));   // avoid leaks

Other hooks: onBeforeMount, onBeforeUpdate, onBeforeUnmount,
onErrorCaptured.

Versus React: these hooks play the role of useEffect but are SPLIT
CLEARLY per lifecycle moment -> easier to read the intent.',
'[]',1680,120),

-- ===== Section 2: Component & Composition =====
('n_vue_sfc','Single File Component (.vue)','Frontend',
'Một component Vue gói gọn trong một file .vue gồm 3 khối:

  <template>
    <button @click="inc">{{ count }}</button>   <!-- HTML + directive -->
  </template>

  <script setup>
    import { ref } from "vue";
    const count = ref(0);
    const inc = () => count.value++;             // logic (Composition API)
  </script>

  <style scoped>
    button { color: teal; }                       /* CSS chỉ áp component này */
  </style>

  • scoped : CSS không rò ra ngoài (Vue thêm thuộc tính data riêng).
  • <script setup> : cú pháp GỌN nhất cho Composition API — biến/hàm
    khai báo tự động expose ra template.

SFC gom cấu trúc + logic + style của một component vào một chỗ.',
'A Vue component is packaged in one .vue file with 3 blocks:

  <template>
    <button @click="inc">{{ count }}</button>   <!-- HTML + directives -->
  </template>

  <script setup>
    import { ref } from "vue";
    const count = ref(0);
    const inc = () => count.value++;             // logic (Composition API)
  </script>

  <style scoped>
    button { color: teal; }                       /* CSS only for this component */
  </style>

  • scoped : CSS does not leak out (Vue adds a unique data attribute).
  • <script setup> : the most CONCISE syntax for the Composition API -
    declared variables/functions are auto-exposed to the template.

An SFC groups a component structure + logic + style in one place.',
'[]',1860,20),

('n_vue_composition','Composition API vs Options API','Frontend',
'Hai cách tổ chức logic component:

  • Options API : chia theo TÙY CHỌN (data, methods, computed, watch).
    Dễ cho người mới nhưng logic của MỘT tính năng bị rải ra nhiều
    khối khi component lớn.
  • Composition API (setup) : gom logic theo TÍNH NĂNG; tái dùng qua
    "composable" (tương đương custom hooks của React).

Composable tái dùng logic:
  // useCounter.js
  export function useCounter(start = 0) {
    const count = ref(start);
    const inc = () => count.value++;
    return { count, inc };
  }
  // trong component: const { count, inc } = useCounter();

Composition API hợp component lớn/logic tái dùng; Options API vẫn ổn
cho component nhỏ. Vue hỗ trợ cả hai.',
'Two ways to organize component logic:

  • Options API : split by OPTIONS (data, methods, computed, watch).
    Beginner-friendly but the logic of ONE feature scatters across
    several blocks as the component grows.
  • Composition API (setup) : group logic by FEATURE; reuse via a
    "composable" (equivalent to React custom hooks).

A composable for reusable logic:
  // useCounter.js
  export function useCounter(start = 0) {
    const count = ref(start);
    const inc = () => count.value++;
    return { count, inc };
  }
  // in a component: const { count, inc } = useCounter();

The Composition API suits large components/reusable logic; the
Options API is fine for small ones. Vue supports both.',
'[]',1940,20),

('n_vue_props_emit','Props, Emit & v-model','Frontend',
'Luồng dữ liệu một chiều: cha truyền xuống con qua PROPS, con báo lên
cha qua EMIT sự kiện.

  <!-- Child.vue -->
  <script setup>
    const props = defineProps(["title"]);
    const emit  = defineEmits(["save"]);
    function onClick() { emit("save", { id: 1 }); }
  </script>

  <!-- Parent -->
  <Child :title="t" @save="onSave" />

v-model = đường tắt cho cặp props + emit (two-way binding tiện):
  <input v-model="text" />
  <!-- tương đương -->
  <input :value="text" @input="text = $event.target.value" />

Component tự làm v-model qua prop modelValue + emit update:modelValue.
Không sửa trực tiếp prop trong con (one-way) — hãy emit để cha đổi.',
'One-way data flow: the parent passes down via PROPS, the child
reports up via EMIT events.

  <!-- Child.vue -->
  <script setup>
    const props = defineProps(["title"]);
    const emit  = defineEmits(["save"]);
    function onClick() { emit("save", { id: 1 }); }
  </script>

  <!-- Parent -->
  <Child :title="t" @save="onSave" />

v-model = shorthand for the props + emit pair (convenient two-way
binding):
  <input v-model="text" />
  <!-- equivalent to -->
  <input :value="text" @input="text = $event.target.value" />

A component implements v-model via a modelValue prop + an
update:modelValue emit. Do not mutate a prop directly in the child
(one-way) - emit so the parent changes it.',
'[]',1860,120),

-- ===== Section 3: Template & Directives =====
('n_vue_directives','Directives','Frontend',
'Directive là thuộc tính đặc biệt (bắt đầu v-) điều khiển DOM trong
template:

  v-if / v-else-if / v-else : GẮN/GỠ element theo điều kiện
  v-show                    : ẩn/hiện bằng CSS (element VẪN trong DOM)
  v-for                     : lặp danh sách (luôn kèm :key)
  v-bind  (viết tắt :)      : ràng buộc thuộc tính  :href="url"
  v-on    (viết tắt @)      : nghe sự kiện  @click="fn"
  v-model                   : two-way binding

  <ul>
    <li v-for="u in users" :key="u.id">{{ u.name }}</li>
  </ul>
  <p v-if="loading">Đang tải...</p>
  <button :disabled="busy" @click="submit">Gửi</button>

v-if (tốn hơn: gắn/gỡ + tạo lại) vs v-show (rẻ khi bật/tắt LIÊN TỤC
vì chỉ đổi CSS display). Đừng dùng v-if chung với v-for trên cùng
một thẻ.',
'Directives are special attributes (starting with v-) that control
the DOM in a template:

  v-if / v-else-if / v-else : ADD/REMOVE an element by condition
  v-show                    : hide/show via CSS (element STAYS in the DOM)
  v-for                     : loop a list (always with :key)
  v-bind  (shorthand :)     : bind an attribute  :href="url"
  v-on    (shorthand @)     : listen to an event  @click="fn"
  v-model                   : two-way binding

  <ul>
    <li v-for="u in users" :key="u.id">{{ u.name }}</li>
  </ul>
  <p v-if="loading">Loading...</p>
  <button :disabled="busy" @click="submit">Send</button>

v-if (more costly: add/remove + recreate) vs v-show (cheap when
toggling FREQUENTLY, since it only changes CSS display). Do not use
v-if together with v-for on the same tag.',
'[]',1680,180),

('n_vue_slots','Slots','Frontend',
'Slot cho phép component CHA chèn nội dung vào chỗ định sẵn trong
component con -> tạo component linh hoạt (tương tự children /
composition của React).

  <!-- Card.vue -->
  <div class="card">
    <slot name="header" />
    <div class="body"><slot /></div>   <!-- slot mặc định -->
  </div>

  <!-- sử dụng -->
  <Card>
    <template #header><h3>Tiêu đề</h3></template>
    <p>Nội dung thân card</p>
  </Card>

Scoped slot (con truyền dữ liệu RA cho cha render):
  <slot name="row" :item="item" />
  <!-- cha: <template #row="{ item }">{{ item.name }}</template> -->

Slot là nền để xây component tái dùng và bố cục linh hoạt.',
'Slots let the PARENT inject content into predefined places in the
child component -> flexible components (similar to React children /
composition).

  <!-- Card.vue -->
  <div class="card">
    <slot name="header" />
    <div class="body"><slot /></div>   <!-- default slot -->
  </div>

  <!-- usage -->
  <Card>
    <template #header><h3>Title</h3></template>
    <p>Card body content</p>
  </Card>

Scoped slot (the child passes data OUT for the parent to render):
  <slot name="row" :item="item" />
  <!-- parent: <template #row="{ item }">{{ item.name }}</template> -->

Slots are the basis for building reusable components and flexible
layouts.',
'[]',1760,180),

-- ===== Section 4: State & Advanced =====
('n_vue_pinia','Pinia (State Management)','Frontend',
'Pinia là thư viện quản lý state chính thức của Vue (thay Vuex cũ),
gọn và hỗ trợ TypeScript tốt.

  // stores/cart.js
  import { defineStore } from "pinia";
  export const useCart = defineStore("cart", {
    state:   () => ({ items: [] }),
    getters: { count: (s) => s.items.length },   // giống computed
    actions: { add(item) { this.items.push(item); } },
  });

  // trong component
  const cart = useCart();
  cart.add(product);
  console.log(cart.count);

Dùng cho state TOÀN CỤC chia sẻ nhiều nơi (giỏ hàng, user đăng nhập,
cấu hình). State CỤC BỘ của một component thì vẫn dùng ref/reactive.
Pinia store cũng reactive -> UI tự cập nhật khi state đổi.',
'Pinia is the official Vue state management library (replacing the
old Vuex), concise and with good TypeScript support.

  // stores/cart.js
  import { defineStore } from "pinia";
  export const useCart = defineStore("cart", {
    state:   () => ({ items: [] }),
    getters: { count: (s) => s.items.length },   // like computed
    actions: { add(item) { this.items.push(item); } },
  });

  // in a component
  const cart = useCart();
  cart.add(product);
  console.log(cart.count);

Use it for GLOBAL state shared across many places (cart, logged-in
user, config). LOCAL component state still uses ref/reactive. A
Pinia store is also reactive -> the UI updates automatically when
state changes.',
'[]',1860,180),

('n_vue_perf','Tối ưu hiệu năng','Frontend',
'Nhờ reactivity mịn, Vue thường ít render thừa, nhưng vẫn có kỹ thuật
tối ưu:

  • v-show thay v-if khi bật/tắt LIÊN TỤC (tránh gắn/gỡ tốn kém).
  • :key ĐÚNG và ổn định trong v-for.
  • computed (có cache) thay vì gọi method trong template (method
    chạy lại mỗi lần render).
  • v-once  : render một lần rồi bỏ qua (nội dung tĩnh).
  • v-memo  : bỏ qua cập nhật khi deps không đổi.
  • <KeepAlive> : giữ (cache) component khi chuyển qua lại, tránh dựng
    lại từ đầu.
  • Lazy load: defineAsyncComponent + tách route -> giảm bundle đầu.

Nguyên tắc chung giống React: đo trước (Vue DevTools), tránh tính
toán nặng trong template, giữ component nhỏ và rõ phụ thuộc.',
'Thanks to fine-grained reactivity, Vue usually has few wasted
renders, but optimization techniques still exist:

  • v-show instead of v-if when toggling FREQUENTLY (avoid costly
    add/remove).
  • Correct, stable :key in v-for.
  • computed (cached) instead of calling a method in the template (a
    method re-runs on every render).
  • v-once  : render once then skip (static content).
  • v-memo  : skip updates when deps are unchanged.
  • <KeepAlive> : keep (cache) a component when switching back and
    forth, avoiding a full rebuild.
  • Lazy load: defineAsyncComponent + route splitting -> smaller
    initial bundle.

The general principle matches React: measure first (Vue DevTools),
avoid heavy computation in templates, keep components small with
clear dependencies.',
'[]',1940,180),

('n_vue_vs_react','Vue vs React','Frontend',
'Cả hai đều component-based, dùng Virtual DOM, dữ liệu một chiều.

  Tiêu chí     | React                    | Vue 3
  -------------|--------------------------|--------------------------
  Reactivity   | thủ công (setState) +    | tự động (Proxy track/
               | so sánh VDOM             | trigger), mịn hơn
  View         | JSX (JavaScript thuần)   | template + directive (SFC)
  Tái dùng     | custom hooks             | composables
  State global | Redux/Zustand (ngoài)    | Pinia (chính thức)
  Học          | linh hoạt, tự lắp ghép   | quy ước rõ, dễ vào
  Hệ sinh thái | rất lớn nhất             | lớn, tích hợp sẵn nhiều

Điểm chung: component, VDOM, reactive UI, có hệ router/tooling.
Khác biệt lớn nhất: Vue theo dõi phụ thuộc TỰ ĐỘNG + dùng template;
React tường minh hơn với JSX + tự chọn thư viện.

Chọn theo đội và dự án; cả hai đều đủ mạnh cho hầu hết ứng dụng.',
'Both are component-based, use a Virtual DOM, and have one-way data
flow.

  Criteria     | React                    | Vue 3
  -------------|--------------------------|--------------------------
  Reactivity   | manual (setState) +      | automatic (Proxy track/
               | VDOM diffing             | trigger), finer-grained
  View         | JSX (plain JavaScript)   | template + directives (SFC)
  Reuse        | custom hooks             | composables
  Global state | Redux/Zustand (external) | Pinia (official)
  Learning     | flexible, assemble it    | clear conventions, easy start
  Ecosystem    | the largest              | large, more built-in

In common: components, VDOM, reactive UI, router/tooling.
Biggest difference: Vue tracks dependencies AUTOMATICALLY + uses
templates; React is more explicit with JSX + you pick libraries.

Choose by team and project; both are powerful enough for most apps.',
'[]',1860,240)
ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ------------------------- EDGES -----------------------------------
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_vue_part-of','root','t_vue','part-of'),
('e_t_vue_s_vue_1_part-of','t_vue','s_vue_1','part-of'),
('e_t_vue_s_vue_2_part-of','t_vue','s_vue_2','part-of'),
('e_t_vue_s_vue_3_part-of','t_vue','s_vue_3','part-of'),
('e_t_vue_s_vue_4_part-of','t_vue','s_vue_4','part-of'),
('e_s_vue_1_n_vue_reactivity','s_vue_1','n_vue_reactivity','part-of'),
('e_s_vue_1_n_vue_computed','s_vue_1','n_vue_computed','part-of'),
('e_s_vue_1_n_vue_lifecycle','s_vue_1','n_vue_lifecycle','part-of'),
('e_s_vue_2_n_vue_sfc','s_vue_2','n_vue_sfc','part-of'),
('e_s_vue_2_n_vue_composition','s_vue_2','n_vue_composition','part-of'),
('e_s_vue_2_n_vue_props_emit','s_vue_2','n_vue_props_emit','part-of'),
('e_s_vue_3_n_vue_directives','s_vue_3','n_vue_directives','part-of'),
('e_s_vue_3_n_vue_slots','s_vue_3','n_vue_slots','part-of'),
('e_s_vue_4_n_vue_pinia','s_vue_4','n_vue_pinia','part-of'),
('e_s_vue_4_n_vue_perf','s_vue_4','n_vue_perf','part-of'),
('e_s_vue_4_n_vue_vs_react','s_vue_4','n_vue_vs_react','part-of'),
('e_n_vue_vs_react_t_reactc_related','n_vue_vs_react','t_reactc','related'),
('e_n_vue_composition_n_rc_rules_related','n_vue_composition','n_rc_rules','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);


-- ===== ĐÀO SÂU PostgreSQL (UPDATE description chi tiết) =====
UPDATE kg_nodes SET
description=
'MVCC = mỗi UPDATE/DELETE KHÔNG ghi đè tại chỗ, mà tạo một PHIÊN BẢN
MỚI của hàng. Nhờ vậy người đọc và người ghi KHÔNG chặn nhau.

Mỗi hàng có 2 cột hệ thống ẩn:
  xmin = id transaction đã TẠO phiên bản này
  xmax = id transaction đã XÓA/thay thế nó (0 = còn sống)

VÍ DỤ TỪNG BƯỚC (2 phiên chạy song song):

  -- Xem cột ẩn:
  SELECT xmin, xmax, bal FROM acc WHERE id = 1;
  -- xmin=100  xmax=0  bal=500   (phiên bản hiện hành)

  Session A  (txid 205)              Session B  (txid 206)
  ----------------------             ----------------------
  BEGIN;
  UPDATE acc SET bal=400
    WHERE id=1;
   -- hàng cũ: xmax=205 (đánh dấu chết)
   -- hàng mới: xmin=205 bal=400
                                     BEGIN;
                                     SELECT bal FROM acc WHERE id=1;
                                     -- 500 (A chưa COMMIT -> thấy bản cũ)
  COMMIT;
                                     SELECT bal FROM acc WHERE id=1;
                                     -- READ COMMITTED  -> 400
                                     -- REPEATABLE READ -> vẫn 500

GIẢI THÍCH TỪNG BƯỚC:
  1. Mỗi transaction có một txid tăng dần.
  2. Khi đọc, PostgreSQL so txid + trạng thái commit để quyết định
     phiên bản nào "nhìn thấy được" với mình (visibility).
  3. A chưa commit -> B thấy bản cũ (KHÔNG có dirty read).
  4. Hàng cũ chỉ bị ĐÁNH DẤU chết (xmax), chưa xóa vật lý -> VACUUM
     dọn sau. Đây là lý do bảng phình (bloat) nếu thiếu VACUUM.

Kết quả: đọc không cần khóa, không chặn ghi -> đồng thời (concurrency) cao.'
,description_en=
'MVCC = an UPDATE/DELETE does NOT overwrite in place; it creates a
NEW VERSION of the row. So readers and writers do NOT block each other.

Every row has 2 hidden system columns:
  xmin = id of the transaction that CREATED this version
  xmax = id of the transaction that DELETED/replaced it (0 = alive)

STEP-BY-STEP EXAMPLE (2 sessions running concurrently):

  -- Inspect the hidden columns:
  SELECT xmin, xmax, bal FROM acc WHERE id = 1;
  -- xmin=100  xmax=0  bal=500   (current version)

  Session A  (txid 205)              Session B  (txid 206)
  ----------------------             ----------------------
  BEGIN;
  UPDATE acc SET bal=400
    WHERE id=1;
   -- old row: xmax=205 (marked dead)
   -- new row: xmin=205 bal=400
                                     BEGIN;
                                     SELECT bal FROM acc WHERE id=1;
                                     -- 500 (A not COMMITted -> sees old)
  COMMIT;
                                     SELECT bal FROM acc WHERE id=1;
                                     -- READ COMMITTED  -> 400
                                     -- REPEATABLE READ -> still 500

STEP-BY-STEP EXPLANATION:
  1. Every transaction has an increasing txid.
  2. On read, PostgreSQL compares txid + commit status to decide which
     version is "visible" to it (visibility).
  3. A has not committed -> B sees the old version (NO dirty read).
  4. The old row is only MARKED dead (xmax), not physically deleted ->
     VACUUM cleans it later. That is why tables bloat without VACUUM.

Result: reads need no locks and do not block writes -> high concurrency.'
WHERE id='n_pg_mvcc';

UPDATE kg_nodes SET
description=
'Mức isolation quyết định một transaction thấy gì từ transaction khác.
PostgreSQL mặc định READ COMMITTED.

VÍ DỤ NON-REPEATABLE READ (ở READ COMMITTED):

  Session A                          Session B
  ---------                          ---------
  BEGIN;
  SELECT bal FROM acc WHERE id=1;    -- 500
                                     BEGIN;
                                     UPDATE acc SET bal=800 WHERE id=1;
                                     COMMIT;
  SELECT bal FROM acc WHERE id=1;    -- 800  <- ĐỌC LẠI RA KHÁC!
  COMMIT;

Muốn A luôn thấy 500 suốt giao dịch -> dùng REPEATABLE READ:

  BEGIN ISOLATION LEVEL REPEATABLE READ;
    SELECT bal FROM acc WHERE id=1;  -- 500 (chụp snapshot tại đây)
    -- (B cập nhật 800 và COMMIT ở giữa)
    SELECT bal FROM acc WHERE id=1;  -- vẫn 500
  COMMIT;

BẢNG TÓM TẮT (mức nào chặn anomaly nào):
  Mức              | Dirty | Non-repeatable | Phantom
  -----------------|-------|----------------|--------
  READ COMMITTED   | chặn  | CÓ THỂ         | CÓ THỂ
  REPEATABLE READ  | chặn  | chặn           | chặn (PG dùng snapshot)
  SERIALIZABLE     | chặn  | chặn           | chặn + chống write-skew

GIẢI THÍCH TỪNG THUẬT NGỮ:
  • Dirty read     : đọc dữ liệu CHƯA commit (PG không bao giờ cho).
  • Non-repeatable : đọc lại CÙNG hàng ra giá trị khác.
  • Phantom        : cùng điều kiện WHERE, lần sau ra THÊM/BỚT hàng.
  • Write-skew     : 2 giao dịch đọc rồi ghi chéo, mỗi cái đúng riêng
                     nhưng cùng nhau phá bất biến -> chỉ SERIALIZABLE chặn.

Mức càng cao càng an toàn nhưng càng nhiều xung đột. SERIALIZABLE có
thể trả lỗi serialization -> ứng dụng phải RETRY giao dịch.'
,description_en=
'The isolation level decides what one transaction sees from others.
PostgreSQL defaults to READ COMMITTED.

NON-REPEATABLE READ EXAMPLE (under READ COMMITTED):

  Session A                          Session B
  ---------                          ---------
  BEGIN;
  SELECT bal FROM acc WHERE id=1;    -- 500
                                     BEGIN;
                                     UPDATE acc SET bal=800 WHERE id=1;
                                     COMMIT;
  SELECT bal FROM acc WHERE id=1;    -- 800  <- RE-READ DIFFERS!
  COMMIT;

To make A always see 500 for the whole transaction -> REPEATABLE READ:

  BEGIN ISOLATION LEVEL REPEATABLE READ;
    SELECT bal FROM acc WHERE id=1;  -- 500 (snapshot taken here)
    -- (B updates to 800 and COMMITs in between)
    SELECT bal FROM acc WHERE id=1;  -- still 500
  COMMIT;

SUMMARY TABLE (which level prevents which anomaly):
  Level            | Dirty | Non-repeatable | Phantom
  -----------------|-------|----------------|--------
  READ COMMITTED   | no    | POSSIBLE       | POSSIBLE
  REPEATABLE READ  | no    | no             | no (PG uses a snapshot)
  SERIALIZABLE     | no    | no             | no + prevents write-skew

TERM-BY-TERM EXPLANATION:
  • Dirty read     : reading UNCOMMITTED data (PG never allows it).
  • Non-repeatable : re-reading the SAME row yields a different value.
  • Phantom        : same WHERE, next time returns MORE/FEWER rows.
  • Write-skew     : two transactions read then write across each other,
                     each valid alone but together break an invariant ->
                     only SERIALIZABLE prevents it.

Higher levels are safer but conflict more. SERIALIZABLE may return a
serialization error -> the app must RETRY the transaction.'
WHERE id='n_pg_isolation';

UPDATE kg_nodes SET
description=
'Người ĐỌC không chặn người GHI (nhờ MVCC). Nhưng hai người GHI cùng
một hàng thì phải chờ nhau.

KHÓA CHỦ ĐỘNG để cập nhật an toàn (chống lost update):

  BEGIN;
    SELECT * FROM acc WHERE id=1 FOR UPDATE;   -- giữ khóa hàng
    UPDATE acc SET bal = bal - 100 WHERE id=1;
  COMMIT;   -- giao dịch khác đụng id=1 phải CHỜ tới đây

VÍ DỤ DEADLOCK (khóa chéo do khác thứ tự):

  Session A                          Session B
  ---------                          ---------
  BEGIN;                             BEGIN;
  UPDATE acc SET bal=bal-100         UPDATE acc SET bal=bal-50
    WHERE id=1;  -- giữ khóa hàng 1    WHERE id=2;  -- giữ khóa hàng 2
  UPDATE acc SET ...                 UPDATE acc SET ...
    WHERE id=2;  -- CHỜ B nhả hàng 2   WHERE id=1;  -- CHỜ A nhả hàng 1
  --> vòng chờ! PostgreSQL tự phát hiện và hủy 1 giao dịch:
      ERROR: deadlock detected

CÁCH TRÁNH (từng bước):
  1. Luôn khóa các hàng theo CÙNG một thứ tự ở mọi nơi (vd id nhỏ
     trước) -> không bao giờ tạo được vòng chờ.
  2. Giữ transaction NGẮN, làm ít việc khi đang giữ khóa.
  3. Hàng đợi công việc: SELECT ... FOR UPDATE SKIP LOCKED
     -> nhiều worker bỏ qua hàng đang bị khóa, không giẫm chân nhau.
  4. Bắt lỗi deadlock (SQLSTATE 40P01) và RETRY giao dịch.

Phân biệt khóa:
  • FOR UPDATE : khóa ghi độc quyền hàng (người khác chờ).
  • FOR SHARE  : cho người khác đọc/khóa share, chặn ghi.'
,description_en=
'READERS do not block WRITERS (thanks to MVCC). But two WRITERS on the
same row must wait for each other.

EXPLICIT LOCK for a safe update (prevents lost update):

  BEGIN;
    SELECT * FROM acc WHERE id=1 FOR UPDATE;   -- hold the row lock
    UPDATE acc SET bal = bal - 100 WHERE id=1;
  COMMIT;   -- other transactions touching id=1 WAIT until here

DEADLOCK EXAMPLE (cross-locking due to different order):

  Session A                          Session B
  ---------                          ---------
  BEGIN;                             BEGIN;
  UPDATE acc SET bal=bal-100         UPDATE acc SET bal=bal-50
    WHERE id=1;  -- holds row 1        WHERE id=2;  -- holds row 2
  UPDATE acc SET ...                 UPDATE acc SET ...
    WHERE id=2;  -- WAITS for B         WHERE id=1;  -- WAITS for A
  --> a wait cycle! PostgreSQL detects it and aborts one transaction:
      ERROR: deadlock detected

HOW TO AVOID (step by step):
  1. Always lock rows in the SAME order everywhere (e.g. smaller id
     first) -> a wait cycle can never form.
  2. Keep transactions SHORT, do little work while holding locks.
  3. Job queues: SELECT ... FOR UPDATE SKIP LOCKED
     -> many workers skip already-locked rows and do not collide.
  4. Catch the deadlock error (SQLSTATE 40P01) and RETRY.

Lock types:
  • FOR UPDATE : exclusive write lock on the row (others wait).
  • FOR SHARE  : lets others read/share-lock, blocks writes.'
WHERE id='n_pg_locking';

UPDATE kg_nodes SET
description=
'EXPLAIN cho biết KẾ HOẠCH; thêm ANALYZE để CHẠY THẬT và xem số liệu
thực tế.

VÍ DỤ + đọc output:

  EXPLAIN ANALYZE
  SELECT * FROM orders WHERE user_id = 42 ORDER BY created_at DESC;

  -- Output mẫu (đọc từ TRONG ra NGOÀI, node thụt sâu chạy trước):
  Sort  (cost=8.31..8.32 rows=5 width=40)
        (actual time=0.045..0.046 rows=5 loops=1)
    Sort Key: created_at DESC
    ->  Index Scan using idx_orders_user on orders
          (cost=0.28..8.29 rows=5 width=40)
          (actual time=0.020..0.030 rows=5 loops=1)
        Index Cond: (user_id = 42)
  Planning Time: 0.10 ms
  Execution Time: 0.07 ms

Ý NGHĨA TỪNG PHẦN:
  • Index Scan using idx_orders_user : CÓ dùng index (tốt).
  • cost=0.28..8.29 : chi phí ƯỚC LƯỢNG (khởi động .. tổng).
  • actual time=... : thời gian THỰC TẾ (ms) do ANALYZE đo.
  • rows=5 (ước lượng) so rows=5 (actual) khớp -> thống kê tốt.
  • loops=1 : node chạy 1 lần (trong Nested Loop có thể nhiều lần).

DẤU HIỆU XẤU CẦN SOI:
  • Seq Scan trên bảng lớn kèm điều kiện lọc  -> thiếu index.
  • rows ước lượng lệch XA rows thật          -> thống kê cũ, chạy ANALYZE.
  • Sort/Hash kèm "external merge Disk"        -> tăng work_mem.

Quy trình: đọc node trong cùng trước, tìm nơi tốn actual time nhất
rồi tối ưu đúng chỗ đó.'
,description_en=
'EXPLAIN shows the PLAN; add ANALYZE to actually RUN it and see real
numbers.

EXAMPLE + reading the output:

  EXPLAIN ANALYZE
  SELECT * FROM orders WHERE user_id = 42 ORDER BY created_at DESC;

  -- Sample output (read INSIDE-OUT, the deeper-indented node runs first):
  Sort  (cost=8.31..8.32 rows=5 width=40)
        (actual time=0.045..0.046 rows=5 loops=1)
    Sort Key: created_at DESC
    ->  Index Scan using idx_orders_user on orders
          (cost=0.28..8.29 rows=5 width=40)
          (actual time=0.020..0.030 rows=5 loops=1)
        Index Cond: (user_id = 42)
  Planning Time: 0.10 ms
  Execution Time: 0.07 ms

MEANING OF EACH PART:
  • Index Scan using idx_orders_user : an index IS used (good).
  • cost=0.28..8.29 : ESTIMATED cost (startup .. total).
  • actual time=... : REAL time (ms) measured by ANALYZE.
  • rows=5 (estimate) vs rows=5 (actual) match -> good statistics.
  • loops=1 : the node ran once (inside a Nested Loop it may run many).

BAD SIGNS TO WATCH:
  • Seq Scan on a big filtered table   -> missing index.
  • estimated rows far from actual rows -> stale stats, run ANALYZE.
  • Sort/Hash with "external merge Disk" -> raise work_mem.

Process: read the innermost node first, find where actual time is
spent, then optimize exactly there.'
WHERE id='n_pg_explain';

UPDATE kg_nodes SET
description=
'PostgreSQL theo mô hình ĐA TIẾN TRÌNH (mỗi kết nối = 1 process backend).

SƠ ĐỒ:
  Client ─┬─► postmaster (cha, cổng 5432) ─fork─► backend (1 / kết nối)
          │                                          │
          │                            ┌ Shared memory ┐
          │                            │ shared_buffers │  (cache trang)
          │                            │ WAL buffers    │
          │                            └────────────────┘
          │                                          │
          └────────────────► data files + WAL trên đĩa
              + background workers: autovacuum, checkpointer, WAL writer

VÒNG ĐỜI MỘT QUERY (từng bước):
  1. Client mở kết nối -> postmaster FORK một backend process riêng.
  2. Backend nhận SQL -> Parser (cú pháp) -> Rewriter (view/rule)
     -> Planner (chọn kế hoạch rẻ nhất) -> Executor (chạy).
  3. Executor đọc trang từ shared_buffers; nếu thiếu -> đọc từ đĩa
     vào buffer (cache lại cho lần sau).
  4. Khi ghi: sửa trang trong buffer + ghi WAL trước (xem node WAL).
  5. Trả kết quả về client.

CẤU HÌNH QUAN TRỌNG (postgresql.conf):
  shared_buffers  = 25% RAM     -- cache trang dữ liệu
  work_mem        = 16MB        -- bộ nhớ sort/hash cho MỖI node query
  max_connections = 100         -- mỗi kết nối là 1 process (khá nặng)

Vì mỗi kết nối là một process tốn tài nguyên -> dùng PgBouncer
(connection pooler) khi có nhiều client, thay vì mở hàng nghìn kết
nối trực tiếp tới PostgreSQL.'
,description_en=
'PostgreSQL uses a MULTI-PROCESS model (each connection = 1 backend
process).

DIAGRAM:
  Client ─┬─► postmaster (parent, port 5432) ─fork─► backend (1 / conn)
          │                                          │
          │                            ┌ Shared memory ┐
          │                            │ shared_buffers │  (page cache)
          │                            │ WAL buffers    │
          │                            └────────────────┘
          │                                          │
          └────────────────► data files + WAL on disk
              + background workers: autovacuum, checkpointer, WAL writer

LIFECYCLE OF ONE QUERY (step by step):
  1. Client connects -> postmaster FORKS a dedicated backend process.
  2. Backend gets SQL -> Parser (syntax) -> Rewriter (views/rules)
     -> Planner (pick the cheapest plan) -> Executor (run it).
  3. Executor reads pages from shared_buffers; on a miss -> read from
     disk into the buffer (cached for next time).
  4. On write: modify the page in the buffer + write WAL first (see WAL).
  5. Return the result to the client.

IMPORTANT CONFIG (postgresql.conf):
  shared_buffers  = 25% RAM     -- data page cache
  work_mem        = 16MB        -- sort/hash memory per query NODE
  max_connections = 100         -- each connection is a process (heavy)

Because each connection is a resource-heavy process -> use PgBouncer
(a connection pooler) with many clients, instead of opening thousands
of direct connections to PostgreSQL.'
WHERE id='n_pg_arch';

UPDATE kg_nodes SET
description=
'Transaction gom nhiều lệnh thành một đơn vị ACID: hoặc thành công
TẤT CẢ (COMMIT), hoặc hủy TẤT CẢ (ROLLBACK).

VÍ DỤ chuyển tiền (phải nguyên tử):
  BEGIN;
    UPDATE acc SET bal = bal - 100 WHERE id = 1;
    UPDATE acc SET bal = bal + 100 WHERE id = 2;
  COMMIT;   -- lỗi giữa chừng (chưa COMMIT) -> ROLLBACK, không mất tiền

SAVEPOINT (rollback MỘT PHẦN, không hủy cả giao dịch):
  BEGIN;
    INSERT INTO orders (...) VALUES (...);
    SAVEPOINT sp1;
    INSERT INTO items (...) VALUES (...);   -- giả sử vi phạm ràng buộc
    ROLLBACK TO sp1;                        -- hủy TỪ sp1, GIỮ order
    INSERT INTO items (...) VALUES (...);   -- thử lại bản đúng
  COMMIT;

XỬ LÝ TRONG CODE (thư viện pg của Node — tự ROLLBACK khi lỗi):
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    await client.query("UPDATE acc SET bal=bal-100 WHERE id=1");
    await client.query("UPDATE acc SET bal=bal+100 WHERE id=2");
    await client.query("COMMIT");
  } catch (e) {
    await client.query("ROLLBACK");   // QUAN TRỌNG: nhả giao dịch lỗi
    throw e;
  } finally {
    client.release();                 // luôn trả kết nối về pool
  }

LƯU Ý: transaction mở LÂU giữ snapshot cũ -> cản VACUUM dọn tuple
chết -> hãy giữ giao dịch NGẮN gọn.'
,description_en=
'A transaction groups statements into one ACID unit: either ALL
succeed (COMMIT) or ALL are undone (ROLLBACK).

MONEY-TRANSFER EXAMPLE (must be atomic):
  BEGIN;
    UPDATE acc SET bal = bal - 100 WHERE id = 1;
    UPDATE acc SET bal = bal + 100 WHERE id = 2;
  COMMIT;   -- a mid-way error (not COMMITted) -> ROLLBACK, no lost money

SAVEPOINT (PARTIAL rollback without aborting the whole transaction):
  BEGIN;
    INSERT INTO orders (...) VALUES (...);
    SAVEPOINT sp1;
    INSERT INTO items (...) VALUES (...);   -- suppose it violates a constraint
    ROLLBACK TO sp1;                        -- undo FROM sp1, KEEP the order
    INSERT INTO items (...) VALUES (...);   -- retry with a correct row
  COMMIT;

HANDLING IN CODE (Node pg library - ROLLBACK on error):
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    await client.query("UPDATE acc SET bal=bal-100 WHERE id=1");
    await client.query("UPDATE acc SET bal=bal+100 WHERE id=2");
    await client.query("COMMIT");
  } catch (e) {
    await client.query("ROLLBACK");   // IMPORTANT: release the failed txn
    throw e;
  } finally {
    client.release();                 // always return the connection to the pool
  }

NOTE: a long-open transaction holds an old snapshot -> it blocks
VACUUM from cleaning dead tuples -> keep transactions SHORT.'
WHERE id='n_pg_txn';

UPDATE kg_nodes SET
description=
'WAL (Write-Ahead Log): mọi thay đổi được ghi vào một log TUẦN TỰ
TRƯỚC khi ghi vào data file. Đây là nền của durability + crash recovery.

SƠ ĐỒ luồng ghi khi COMMIT:
  UPDATE ...
    │
    ▼
  1. sửa trang trong shared_buffers (RAM)          [nhanh]
  2. ghi bản ghi WAL -> WAL buffer -> đĩa,
     + fsync khi COMMIT                            [ĐIỂM BỀN VỮNG]
  3. trả OK cho client
  ... sau đó (không đồng bộ với client):
  4. checkpoint: flush các trang "bẩn" xuống data file

VÌ SAO NHANH MÀ VẪN AN TOÀN:
  • WAL ghi TUẦN TỰ (append) -> nhanh hơn ghi ngẫu nhiên vào data file.
  • Chỉ cần WAL đã fsync là COMMIT an toàn; data file cập nhật sau.
  • Mất điện -> khởi động lại sẽ REPLAY WAL từ checkpoint gần nhất để
    khôi phục mọi thay đổi đã commit.

WAL CÒN DÙNG CHO:
  • Streaming replication (replica đọc WAL của primary).
  • PITR (Point-In-Time Recovery): backup nền + WAL -> khôi phục về
    đúng một thời điểm.

CẤU HÌNH:
  fsync = on              -- KHÔNG tắt ở production (tắt = mất an toàn)
  wal_level = replica     -- đủ cho replication
  synchronous_commit = on -- on (an toàn) / off (nhanh, có thể mất vài
                          --   giao dịch cuối nếu crash)'
,description_en=
'WAL (Write-Ahead Log): every change is written SEQUENTIALLY to a log
BEFORE being written to data files. This is the basis of durability +
crash recovery.

WRITE FLOW ON COMMIT:
  UPDATE ...
    │
    ▼
  1. modify the page in shared_buffers (RAM)        [fast]
  2. write the WAL record -> WAL buffer -> disk,
     + fsync on COMMIT                              [DURABILITY POINT]
  3. return OK to the client
  ... later (not in sync with the client):
  4. checkpoint: flush "dirty" pages to the data files

WHY IT IS FAST YET SAFE:
  • WAL is written SEQUENTIALLY (append) -> faster than random writes
    into data files.
  • Once WAL is fsynced the COMMIT is safe; data files update later.
  • On power loss -> on restart it REPLAYS WAL from the last checkpoint
    to recover all committed changes.

WAL IS ALSO USED FOR:
  • Streaming replication (a replica reads the primary WAL).
  • PITR (Point-In-Time Recovery): base backup + WAL -> restore to an
    exact moment.

CONFIG:
  fsync = on              -- do NOT turn off in production (unsafe)
  wal_level = replica     -- enough for replication
  synchronous_commit = on -- on (safe) / off (fast, may lose the last
                          --   few transactions on a crash)'
WHERE id='n_pg_wal';

UPDATE kg_nodes SET
description=
'MVCC để lại tuple CHẾT (dead) sau mỗi UPDATE/DELETE. VACUUM dọn chúng
để tái dùng không gian; autovacuum chạy tự động ở nền.

XEM tình trạng dead tuple + lần vacuum gần nhất:
  SELECT relname, n_live_tup, n_dead_tup, last_autovacuum
  FROM pg_stat_user_tables
  ORDER BY n_dead_tup DESC;

CÁC LỆNH:
  VACUUM my_table;            -- đánh dấu không gian tuple chết là tái
                              --   dùng được (KHÔNG trả về OS), cập nhật FSM
  VACUUM (ANALYZE) my_table;  -- vacuum + cập nhật thống kê cho planner
  VACUUM FULL my_table;       -- nén bảng, TRẢ không gian cho OS, nhưng
                              --   KHÓA bảng độc quyền (tránh giờ cao điểm)
  ANALYZE my_table;           -- chỉ cập nhật thống kê

GIẢI THÍCH:
  • VACUUM thường : nhanh, không khóa nặng, đủ cho vận hành hàng ngày.
  • VACUUM FULL   : viết lại TOÀN BỘ bảng -> giành lại đĩa nhưng CHẶN
    đọc/ghi -> chỉ dùng khi bloat nặng, trong cửa sổ bảo trì.

DẤU HIỆU CẦN CHÚ Ý:
  • n_dead_tup lớn / bảng phình dần -> autovacuum không theo kịp; chỉnh
    autovacuum_vacuum_scale_factor thấp hơn cho bảng ghi nhiều.
  • Transaction ID wraparound (nguy hiểm) -> PG buộc vacuum khẩn cấp;
    đừng để transaction dài hoặc replication slot treo giữ tuple chết.'
,description_en=
'MVCC leaves DEAD tuples behind after each UPDATE/DELETE. VACUUM cleans
them so the space can be reused; autovacuum runs automatically in the
background.

CHECK dead-tuple status + last vacuum:
  SELECT relname, n_live_tup, n_dead_tup, last_autovacuum
  FROM pg_stat_user_tables
  ORDER BY n_dead_tup DESC;

COMMANDS:
  VACUUM my_table;            -- mark dead-tuple space reusable (does
                              --   NOT return to OS), update the FSM
  VACUUM (ANALYZE) my_table;  -- vacuum + refresh planner statistics
  VACUUM FULL my_table;       -- compact the table, RETURN space to the
                              --   OS, but EXCLUSIVELY locks it (off-peak)
  ANALYZE my_table;           -- only refresh statistics

EXPLANATION:
  • Plain VACUUM : fast, no heavy lock, enough for daily operations.
  • VACUUM FULL  : rewrites the WHOLE table -> reclaims disk but BLOCKS
    reads/writes -> use only for heavy bloat, in a maintenance window.

WARNING SIGNS:
  • Large n_dead_tup / a steadily growing table -> autovacuum cannot
    keep up; lower autovacuum_vacuum_scale_factor for write-heavy tables.
  • Transaction ID wraparound (dangerous) -> PG forces an emergency
    vacuum; do not let long transactions or replication slots pin dead
    tuples.'
WHERE id='n_pg_vacuum';

UPDATE kg_nodes SET
description=
'B-tree là index mặc định: hợp cho =, <, >, BETWEEN, ORDER BY và
LIKE ''abc%'' (tiền tố).

SƠ ĐỒ (cây cân bằng, lá liên kết đôi):
        [ 50 | 100 ]
         /     |     \
   [..30] [50..80] [100..]
      │       │        │
    lá ↔    lá ↔      lá ↔    -> quét range nhanh nhờ lá nối nhau

TẠO & DÙNG:
  CREATE INDEX idx_u_email ON users (email);
  -- phục vụ: WHERE email = ... ; ORDER BY email ; email LIKE ''a%''

INDEX NHIỀU CỘT (thứ tự cột QUAN TRỌNG — leftmost prefix):
  CREATE INDEX idx_o ON orders (user_id, created_at);
  -- ✓ WHERE user_id = 42
  -- ✓ WHERE user_id = 42 AND created_at > ''2026-01-01''
  -- ✗ WHERE created_at > ...    (bỏ cột đầu -> index kém tác dụng)

PARTIAL INDEX (chỉ index phần cần -> nhỏ & nhanh):
  CREATE INDEX idx_active ON users (email) WHERE active = true;

EXPRESSION INDEX (khi query bọc hàm quanh cột):
  -- WHERE lower(email) = ... sẽ KHÔNG dùng index thường
  CREATE INDEX idx_lower_email ON users (lower(email));

Kiểm chứng: EXPLAIN thấy "Index Scan" / "Index Cond" -> index có tác dụng.'
,description_en=
'B-tree is the default index: good for =, <, >, BETWEEN, ORDER BY, and
LIKE ''abc%'' (prefix).

DIAGRAM (balanced tree, doubly-linked leaves):
        [ 50 | 100 ]
         /     |     \
   [..30] [50..80] [100..]
      │       │        │
    leaf ↔  leaf ↔   leaf ↔   -> fast range scans via linked leaves

CREATE & USE:
  CREATE INDEX idx_u_email ON users (email);
  -- serves: WHERE email = ... ; ORDER BY email ; email LIKE ''a%''

MULTI-COLUMN INDEX (column order MATTERS - leftmost prefix):
  CREATE INDEX idx_o ON orders (user_id, created_at);
  -- OK  WHERE user_id = 42
  -- OK  WHERE user_id = 42 AND created_at > ''2026-01-01''
  -- NO  WHERE created_at > ...    (skips the first column -> weak)

PARTIAL INDEX (index only what you need -> small & fast):
  CREATE INDEX idx_active ON users (email) WHERE active = true;

EXPRESSION INDEX (when a query wraps a function around a column):
  -- WHERE lower(email) = ... will NOT use a plain index
  CREATE INDEX idx_lower_email ON users (lower(email));

Verify: EXPLAIN showing "Index Scan" / "Index Cond" -> the index works.'
WHERE id='n_pg_btree';

UPDATE kg_nodes SET
description=
'Planner là bộ tối ưu DỰA TRÊN CHI PHÍ: ước lượng cost của nhiều kế
hoạch rồi chọn cái RẺ nhất, dựa vào THỐNG KÊ (pg_statistic, cập nhật
bởi ANALYZE).

VÍ DỤ — vì sao planner BỎ QUA index:

  -- Sau khi nạp 1 triệu dòng nhưng CHƯA analyze:
  EXPLAIN SELECT * FROM orders WHERE user_id = 42;
  -- Seq Scan ... rows=1     (ước lượng SAI vì thống kê cũ)

  ANALYZE orders;            -- cập nhật thống kê
  EXPLAIN SELECT * FROM orders WHERE user_id = 42;
  -- Index Scan ... rows=5000 (giờ ước lượng đúng -> chọn index)

LÝ DO PLANNER KHÔNG DÙNG INDEX (và cách xử lý):
  1. Bảng nhỏ            -> Seq Scan nhanh hơn (bình thường, kệ nó).
  2. Khớp quá nhiều hàng (> ~5-10% bảng) -> quét tuần tự rẻ hơn.
  3. Thống kê cũ         -> chạy ANALYZE (hoặc chờ autovacuum analyze).
  4. Hàm bọc quanh cột   -> WHERE lower(email)=... -> tạo expression index.
  5. Lệch kiểu dữ liệu   -> WHERE int_col = ''5'' (so string) -> ép đúng kiểu.

CÔNG CỤ:
  • ANALYZE / auto-analyze cập nhật thống kê phân bố dữ liệu.
  • ALTER TABLE t ALTER COLUMN c SET STATISTICS 1000; -- cột lệch phân bố.
  • Luôn EXPLAIN ANALYZE để XÁC NHẬN, đừng đoán theo cảm giác.'
,description_en=
'The planner is a COST-BASED optimizer: it estimates the cost of many
plans and picks the CHEAPEST, based on STATISTICS (pg_statistic,
updated by ANALYZE).

EXAMPLE - why the planner IGNORES an index:

  -- After loading 1 million rows but WITHOUT analyzing:
  EXPLAIN SELECT * FROM orders WHERE user_id = 42;
  -- Seq Scan ... rows=1     (WRONG estimate due to stale stats)

  ANALYZE orders;            -- refresh statistics
  EXPLAIN SELECT * FROM orders WHERE user_id = 42;
  -- Index Scan ... rows=5000 (now the estimate is right -> uses index)

WHY THE PLANNER DOES NOT USE AN INDEX (and the fix):
  1. Small table         -> Seq Scan is faster (normal, leave it).
  2. Matches too many rows (> ~5-10% of the table) -> seq scan cheaper.
  3. Stale statistics    -> run ANALYZE (or wait for autovacuum analyze).
  4. Function on a column -> WHERE lower(email)=... -> make an expression index.
  5. Type mismatch       -> WHERE int_col = ''5'' (vs string) -> cast correctly.

TOOLS:
  • ANALYZE / auto-analyze refresh data-distribution statistics.
  • ALTER TABLE t ALTER COLUMN c SET STATISTICS 1000; -- for skewed columns.
  • Always EXPLAIN ANALYZE to CONFIRM, do not guess.'
WHERE id='n_pg_planner';

UPDATE kg_nodes SET
description=
'Ngoài B-tree, PostgreSQL có index chuyên biệt cho từng loại dữ liệu:

  GIN  : giá trị chứa NHIỀU phần tử — JSONB, mảng, full-text search.
  GiST : dữ liệu hình học/không gian (PostGIS), phạm vi (range).
  BRIN : bảng RẤT lớn, dữ liệu sắp theo thứ tự tự nhiên (log theo thời
         gian) — index cực nhỏ.
  Hash : chỉ cho so sánh = (ít dùng hơn B-tree).

GIN cho JSONB (tìm theo chứa/khóa):
  CREATE INDEX idx_doc ON products USING GIN (data);
  SELECT * FROM products WHERE data @> ''{"brand":"acme"}'';

GIN cho MẢNG (tìm phần tử trong mảng):
  CREATE INDEX idx_tags ON posts USING GIN (tags);
  SELECT * FROM posts WHERE tags @> ARRAY[''vip''];

GIN full-text search:
  CREATE INDEX idx_fts ON docs USING GIN (to_tsvector(''english'', body));
  SELECT * FROM docs
   WHERE to_tsvector(''english'', body) @@ plainto_tsquery(''postgres'');

BRIN cho bảng log khổng lồ theo thời gian:
  CREATE INDEX idx_ts ON logs USING BRIN (created_at);
  -- nhỏ hơn B-tree hàng chục lần, tốt khi dữ liệu chèn theo thứ tự thời gian

Chọn ĐÚNG loại index theo DẠNG truy vấn là chìa khóa tối ưu.'
,description_en=
'Besides B-tree, PostgreSQL has index types specialized per data kind:

  GIN  : values containing MANY elements — JSONB, arrays, full-text.
  GiST : geometric/spatial data (PostGIS), ranges.
  BRIN : VERY large tables with naturally ordered data (time-series
         logs) — a tiny index.
  Hash : only for = comparisons (less used than B-tree).

GIN for JSONB (containment/key search):
  CREATE INDEX idx_doc ON products USING GIN (data);
  SELECT * FROM products WHERE data @> ''{"brand":"acme"}'';

GIN for ARRAYS (find an element in an array):
  CREATE INDEX idx_tags ON posts USING GIN (tags);
  SELECT * FROM posts WHERE tags @> ARRAY[''vip''];

GIN full-text search:
  CREATE INDEX idx_fts ON docs USING GIN (to_tsvector(''english'', body));
  SELECT * FROM docs
   WHERE to_tsvector(''english'', body) @@ plainto_tsquery(''postgres'');

BRIN for a huge time-series log table:
  CREATE INDEX idx_ts ON logs USING BRIN (created_at);
  -- tens of times smaller than B-tree, great when data is inserted in
  -- time order

Choosing the RIGHT index type for the query shape is the key to tuning.'
WHERE id='n_pg_index_types';

UPDATE kg_nodes SET
description=
'JSONB lưu JSON ở dạng nhị phân đã phân giải -> truy vấn nhanh, index
được; khác kiểu json (lưu text nguyên văn, chậm khi truy vấn).

TẠO & CHÈN:
  CREATE TABLE products (id serial PRIMARY KEY, data jsonb);
  INSERT INTO products (data) VALUES
    (''{"name":"Phone","brand":"acme","price":300,"tags":["new"]}'');

TRUY VẤN — các toán tử hay dùng:
  data->''brand''    -> giá trị dạng jsonb   ("acme")
  data->>''brand''   -> giá trị dạng text    (acme)
  data#>>''{a,b}''   -> lấy sâu theo đường dẫn
  data @> ''{...}''  -> CHỨA (containment), dùng được GIN index
  data ? ''brand''   -> khóa có tồn tại không?

  SELECT data->>''name'' AS name
  FROM products
  WHERE data @> ''{"brand":"acme"}''
    AND (data->>''price'')::int > 100;

CẬP NHẬT một field (jsonb_set):
  UPDATE products
     SET data = jsonb_set(data, ''{price}'', ''350'')
   WHERE id = 1;

INDEX cho truy vấn containment:
  CREATE INDEX idx_data ON products USING GIN (data);

KHI NÀO DÙNG: dữ liệu bán cấu trúc/linh hoạt (thuộc tính hay đổi). Vẫn
nên chuẩn hóa thành cột riêng cho những trường hay lọc/nối/khóa ngoại.'
,description_en=
'JSONB stores JSON in a parsed binary form -> fast to query and can be
indexed; unlike the json type (raw text, slow to query).

CREATE & INSERT:
  CREATE TABLE products (id serial PRIMARY KEY, data jsonb);
  INSERT INTO products (data) VALUES
    (''{"name":"Phone","brand":"acme","price":300,"tags":["new"]}'');

QUERY - common operators:
  data->''brand''    -> value as jsonb   ("acme")
  data->>''brand''   -> value as text    (acme)
  data#>>''{a,b}''   -> deep get by path
  data @> ''{...}''  -> CONTAINMENT, can use a GIN index
  data ? ''brand''   -> does the key exist?

  SELECT data->>''name'' AS name
  FROM products
  WHERE data @> ''{"brand":"acme"}''
    AND (data->>''price'')::int > 100;

UPDATE a single field (jsonb_set):
  UPDATE products
     SET data = jsonb_set(data, ''{price}'', ''350'')
   WHERE id = 1;

INDEX for containment queries:
  CREATE INDEX idx_data ON products USING GIN (data);

WHEN TO USE: semi-structured/flexible data (changing attributes).
Still normalize into real columns the fields you often filter/join on.'
WHERE id='n_pg_jsonb';

UPDATE kg_nodes SET
description=
'CTE (WITH) đặt tên cho truy vấn con -> dễ đọc, chia nhỏ query lớn; hỗ
trợ đệ quy. Window function tính TRÊN một khung hàng mà KHÔNG gộp nhóm
(giữ nguyên từng dòng).

CTE (chia nhiều bước rõ ràng):
  WITH recent AS (
    SELECT * FROM orders
    WHERE created_at > now() - interval ''7 days''
  ),
  by_user AS (
    SELECT user_id, count(*) AS n FROM recent GROUP BY user_id
  )
  SELECT * FROM by_user WHERE n > 5;

WINDOW FUNCTION (thêm cột tính toán, GIỮ từng hàng):
  SELECT name, dept, salary,
         rank()      OVER (PARTITION BY dept ORDER BY salary DESC) AS rnk,
         avg(salary) OVER (PARTITION BY dept)                      AS dept_avg
  FROM employees;

  -- Kết quả mẫu:
  --  name  dept  salary  rnk  dept_avg
  --  An    IT     1200    1     1000
  --  Binh  IT      800    2     1000

GIẢI THÍCH:
  • PARTITION BY dept    : chia nhóm theo phòng (như GROUP BY nhưng
    KHÔNG gộp dòng lại).
  • ORDER BY salary DESC : thứ tự trong nhóm để rank() đánh số.
  • Hàm khác: row_number(), dense_rank(), lag()/lead() (dòng trước/sau),
    sum() OVER (...) để cộng dồn.

CTE ĐỆ QUY (duyệt cây/đồ thị — vd cây danh mục):
  WITH RECURSIVE tree AS (
    SELECT id, parent_id, name FROM cat WHERE id = 1        -- gốc
    UNION ALL
    SELECT c.id, c.parent_id, c.name
    FROM cat c JOIN tree t ON c.parent_id = t.id            -- bước đệ quy
  )
  SELECT * FROM tree;'
,description_en=
'A CTE (WITH) names a subquery -> readable, splits a big query; supports
recursion. A window function computes OVER a frame of rows WITHOUT
collapsing groups (keeps each row).

CTE (clear multi-step):
  WITH recent AS (
    SELECT * FROM orders
    WHERE created_at > now() - interval ''7 days''
  ),
  by_user AS (
    SELECT user_id, count(*) AS n FROM recent GROUP BY user_id
  )
  SELECT * FROM by_user WHERE n > 5;

WINDOW FUNCTION (add computed columns, KEEP each row):
  SELECT name, dept, salary,
         rank()      OVER (PARTITION BY dept ORDER BY salary DESC) AS rnk,
         avg(salary) OVER (PARTITION BY dept)                      AS dept_avg
  FROM employees;

  -- Sample result:
  --  name  dept  salary  rnk  dept_avg
  --  An    IT     1200    1     1000
  --  Binh  IT      800    2     1000

EXPLANATION:
  • PARTITION BY dept    : group by department (like GROUP BY but does
    NOT collapse rows).
  • ORDER BY salary DESC : order within the group so rank() numbers them.
  • Others: row_number(), dense_rank(), lag()/lead() (prev/next row),
    sum() OVER (...) for a running total.

RECURSIVE CTE (walk a tree/graph - e.g. a category tree):
  WITH RECURSIVE tree AS (
    SELECT id, parent_id, name FROM cat WHERE id = 1        -- root
    UNION ALL
    SELECT c.id, c.parent_id, c.name
    FROM cat c JOIN tree t ON c.parent_id = t.id            -- recursive step
  )
  SELECT * FROM tree;'
WHERE id='n_pg_cte_window';

UPDATE kg_nodes SET
description=
'PostgreSQL nổi bật vì hệ KIỂU giàu, giảm xử lý ở tầng app:

  uuid     : khóa phân tán    -> gen_random_uuid()
  array    : mảng             -> int[] , text[]
  enum     : tập giá trị cố định
  range    : khoảng           -> int4range, tstzrange
  jsonb    : tài liệu linh hoạt
  inet     : địa chỉ IP/mạng
  tsvector : full-text search

VÍ DỤ MẢNG:
  CREATE TABLE ev (id serial, tags text[]);
  INSERT INTO ev (tags) VALUES (ARRAY[''vip'',''sale'']);
  SELECT * FROM ev WHERE ''vip'' = ANY(tags);      -- có phần tử vip?
  SELECT * FROM ev WHERE tags @> ARRAY[''vip''];   -- chứa (dùng GIN index)

VÍ DỤ ENUM:
  CREATE TYPE mood AS ENUM (''low'',''ok'',''high'');
  CREATE TABLE t (m mood);

VÍ DỤ RANGE + ràng buộc loại trừ (chặn đặt phòng trùng giờ):
  CREATE TABLE booking (
    room   int,
    during tstzrange,
    EXCLUDE USING gist (room WITH =, during WITH &&)
  );
  -- && = giao nhau: 2 booking CÙNG phòng mà giao giờ -> bị CHẶN ngay ở DB

Dùng ĐÚNG kiểu giúp ràng buộc dữ liệu chặt và query gọn hơn.'
,description_en=
'PostgreSQL stands out for its rich TYPE system, reducing app-side work:

  uuid     : distributed keys -> gen_random_uuid()
  array    : arrays           -> int[] , text[]
  enum     : a fixed set of values
  range    : ranges           -> int4range, tstzrange
  jsonb    : flexible documents
  inet     : IP/network addresses
  tsvector : full-text search

ARRAY EXAMPLE:
  CREATE TABLE ev (id serial, tags text[]);
  INSERT INTO ev (tags) VALUES (ARRAY[''vip'',''sale'']);
  SELECT * FROM ev WHERE ''vip'' = ANY(tags);      -- has element vip?
  SELECT * FROM ev WHERE tags @> ARRAY[''vip''];   -- contains (uses GIN)

ENUM EXAMPLE:
  CREATE TYPE mood AS ENUM (''low'',''ok'',''high'');
  CREATE TABLE t (m mood);

RANGE + EXCLUSION constraint (prevent overlapping bookings):
  CREATE TABLE booking (
    room   int,
    during tstzrange,
    EXCLUDE USING gist (room WITH =, during WITH &&)
  );
  -- && = overlap: two bookings for the SAME room with overlapping time
  -- are BLOCKED right in the DB

Using the RIGHT type enforces data constraints tightly and keeps
queries cleaner.'
WHERE id='n_pg_types';

UPDATE kg_nodes SET
description=
'Partitioning chia một bảng lớn thành nhiều bảng con theo khóa -> query
chỉ quét phần liên quan (partition pruning) và bảo trì dễ (xóa cả
partition cũ thay vì DELETE hàng loạt).

KIỂU: RANGE (theo khoảng), LIST (theo danh sách), HASH (chia đều).

VÍ DỤ RANGE theo thời gian:
  CREATE TABLE logs (id bigint, ts timestamptz, msg text)
    PARTITION BY RANGE (ts);

  CREATE TABLE logs_2026_01 PARTITION OF logs
    FOR VALUES FROM (''2026-01-01'') TO (''2026-02-01'');
  CREATE TABLE logs_2026_02 PARTITION OF logs
    FOR VALUES FROM (''2026-02-01'') TO (''2026-03-01'');

PARTITION PRUNING (planner tự loại partition không khớp):
  EXPLAIN SELECT * FROM logs WHERE ts >= ''2026-02-10'';
  -- chỉ quét logs_2026_02, BỎ QUA logs_2026_01 -> nhanh hơn nhiều

BẢO TRÌ dễ:
  DROP TABLE logs_2026_01;   -- xóa dữ liệu tháng cũ TỨC THÌ (không DELETE)

KẾT HỢP: dùng BRIN index trên cột thời gian trong mỗi partition. Chỉ
nên partition khi bảng THỰC SỰ lớn (hàng chục triệu dòng trở lên).'
,description_en=
'Partitioning splits a large table into child tables by a key -> queries
scan only the relevant part (partition pruning) and maintenance is easy
(drop a whole old partition instead of a mass DELETE).

KINDS: RANGE (by range), LIST (by a list), HASH (even split).

RANGE-BY-TIME EXAMPLE:
  CREATE TABLE logs (id bigint, ts timestamptz, msg text)
    PARTITION BY RANGE (ts);

  CREATE TABLE logs_2026_01 PARTITION OF logs
    FOR VALUES FROM (''2026-01-01'') TO (''2026-02-01'');
  CREATE TABLE logs_2026_02 PARTITION OF logs
    FOR VALUES FROM (''2026-02-01'') TO (''2026-03-01'');

PARTITION PRUNING (the planner drops non-matching partitions):
  EXPLAIN SELECT * FROM logs WHERE ts >= ''2026-02-10'';
  -- scans only logs_2026_02, SKIPS logs_2026_01 -> much faster

EASY MAINTENANCE:
  DROP TABLE logs_2026_01;   -- delete an old month INSTANTLY (no DELETE)

COMBINE: use a BRIN index on the time column in each partition. Only
partition when the table is TRULY large (tens of millions of rows or more).'
WHERE id='n_pg_partition';



-- ===== ĐÀO SÂU MySQL (UPDATE chi tiết) =====
UPDATE kg_nodes SET
description=
'InnoDB là engine mặc định của MySQL: ACID, MVCC, khóa mức hàng.

SƠ ĐỒ thành phần:
  ┌ Buffer Pool (RAM) ┐  cache trang data + index (quan trọng nhất)
  │  data pages        │
  │  index pages       │
  └────────────────────┘
        │ đọc/ghi
        ▼
  ┌ Log & recovery ┐
  │ Redo log    -> ghi trước thay đổi, phục hồi sau crash (như WAL)
  │ Undo log    -> lưu bản CŨ của hàng -> phục vụ MVCC + ROLLBACK
  │ Doublewrite -> chống trang ghi dở (torn page) khi crash
  └────────────────┘
        │
        ▼
  file .ibd trên đĩa

LUỒNG GHI khi COMMIT (giống WAL của PostgreSQL):
  1. sửa trang trong Buffer Pool (RAM)
  2. ghi Redo log + flush khi COMMIT        [điểm bền vững]
  3. trang "bẩn" flush xuống .ibd sau (checkpoint)

CẤU HÌNH QUAN TRỌNG NHẤT:
  innodb_buffer_pool_size = 60-75% RAM   -- đòn bẩy hiệu năng lớn nhất
  innodb_flush_log_at_trx_commit = 1     -- 1: an toàn nhất (fsync mỗi commit)
                                         -- 2/0: nhanh hơn, có thể mất giao dịch
                                         --      cuối khi crash
  innodb_log_file_size = 512M            -- redo log lớn -> ít checkpoint hơn

Chẩn đoán: SHOW ENGINE INNODB STATUS; -> xem buffer pool, deadlock gần nhất.'
,description_en=
'InnoDB is the default MySQL engine: ACID, MVCC, row-level locking.

COMPONENT DIAGRAM:
  ┌ Buffer Pool (RAM) ┐  caches data + index pages (most important)
  │  data pages        │
  │  index pages       │
  └────────────────────┘
        │ read/write
        ▼
  ┌ Log & recovery ┐
  │ Redo log    -> logs changes ahead, recovers after crash (like WAL)
  │ Undo log    -> keeps OLD row versions -> powers MVCC + ROLLBACK
  │ Doublewrite -> protects against torn-page writes on crash
  └────────────────┘
        │
        ▼
  .ibd files on disk

WRITE FLOW ON COMMIT (like PostgreSQL WAL):
  1. modify the page in the Buffer Pool (RAM)
  2. write the Redo log + flush on COMMIT   [durability point]
  3. dirty pages flush to .ibd later (checkpoint)

MOST IMPORTANT CONFIG:
  innodb_buffer_pool_size = 60-75% RAM   -- the biggest performance lever
  innodb_flush_log_at_trx_commit = 1     -- 1: safest (fsync each commit)
                                         -- 2/0: faster, may lose the last
                                         --      transactions on a crash
  innodb_log_file_size = 512M            -- larger redo log -> fewer checkpoints

Diagnose: SHOW ENGINE INNODB STATUS; -> buffer pool, latest deadlock.'
WHERE id='n_my_innodb';

UPDATE kg_nodes SET
description=
'InnoDB lưu bảng NHƯ một B+Tree theo PRIMARY KEY (clustered index):
dữ liệu hàng nằm NGAY trong lá của cây PK. Khác PostgreSQL (heap riêng).

SƠ ĐỒ tra cứu qua secondary index (TỐN 2 BƯỚC):

  Secondary index (idx theo email)
     lá: email -> PRIMARY KEY         (KHÔNG phải con trỏ tới hàng)
                     │
                     ▼   (lookup lần 2 = bookmark lookup)
  Clustered index (theo PK)
     lá: PK -> TOÀN BỘ dữ liệu hàng

VÍ DỤ:
  CREATE TABLE users (
    id    BIGINT PRIMARY KEY AUTO_INCREMENT,   -- clustered theo id
    email VARCHAR(255),
    name  VARCHAR(100),
    INDEX idx_email (email)                     -- secondary index
  );

  SELECT name FROM users WHERE email = ''a@x.com'';
  -- Bước 1: tìm trong idx_email -> ra id (vd 42)
  -- Bước 2: tìm id=42 trong clustered index -> lấy cả hàng (có name)

HỆ QUẢ THỰC TẾ:
  • PK nên NHỎ và TĂNG DẦN (BIGINT AUTO_INCREMENT). PK ngẫu nhiên
    (UUID v4) -> chèn phân mảnh trang + phình MỌI secondary index (vì
    mỗi secondary đều ngầm chứa PK ở lá).
  • Muốn tránh bước 2 (bookmark lookup): dùng covering index (node kế).'
,description_en=
'InnoDB stores the table AS a B+Tree ordered by the PRIMARY KEY
(clustered index): row data lives RIGHT in the PK leaves. Unlike
PostgreSQL (a separate heap).

DIAGRAM of a secondary-index lookup (COSTS 2 STEPS):

  Secondary index (idx on email)
     leaf: email -> PRIMARY KEY       (NOT a pointer to the row)
                     │
                     ▼   (second lookup = bookmark lookup)
  Clustered index (by PK)
     leaf: PK -> the WHOLE row data

EXAMPLE:
  CREATE TABLE users (
    id    BIGINT PRIMARY KEY AUTO_INCREMENT,   -- clustered by id
    email VARCHAR(255),
    name  VARCHAR(100),
    INDEX idx_email (email)                     -- secondary index
  );

  SELECT name FROM users WHERE email = ''a@x.com'';
  -- Step 1: search idx_email -> get the id (e.g. 42)
  -- Step 2: search id=42 in the clustered index -> fetch the row (has name)

REAL-WORLD CONSEQUENCES:
  • The PK should be SMALL and INCREASING (BIGINT AUTO_INCREMENT). A
    random PK (UUID v4) -> fragmented page inserts + bloats EVERY
    secondary index (each secondary implicitly holds the PK in its leaf).
  • To avoid step 2 (the bookmark lookup): use a covering index (next node).'
WHERE id='n_my_btree';

UPDATE kg_nodes SET
description=
'InnoDB khóa mức HÀNG, nhưng ở REPEATABLE READ (mặc định) còn khóa cả
KHOẢNG TRỐNG để chống phantom.

3 LOẠI KHÓA:
  Record lock  : khóa đúng một hàng chỉ mục
  Gap lock     : khóa KHOẢNG giữa 2 giá trị index (chặn chèn vào giữa)
  Next-key lock: record + gap (mặc định ở REPEATABLE READ)

VÍ DỤ khóa để cập nhật an toàn:
  START TRANSACTION;
    SELECT * FROM acc WHERE id = 1 FOR UPDATE;   -- khóa hàng id=1
    UPDATE acc SET bal = bal - 100 WHERE id = 1;
  COMMIT;   -- giao dịch khác đụng id=1 phải CHỜ tới đây

VÍ DỤ next-key lock chặn phantom (ở REPEATABLE READ):
  SELECT * FROM t WHERE age BETWEEN 20 AND 30 FOR UPDATE;
  -- khóa các hàng 20..30 VÀ khoảng trống -> giao dịch khác KHÔNG chèn
  --   được age=25 vào giữa -> không có phantom

VÍ DỤ DEADLOCK (khóa chéo thứ tự) + xử lý:
  Session A: UPDATE acc ... WHERE id=1;  rồi  WHERE id=2;
  Session B: UPDATE acc ... WHERE id=2;  rồi  WHERE id=1;
  --> InnoDB phát hiện, rollback giao dịch RẺ hơn:
      ERROR 1213 (40001): Deadlock found when trying to get lock
  --> Ứng dụng nên BẮT lỗi 1213 và RETRY giao dịch.

TRÁNH: khóa theo CÙNG thứ tự; transaction NGẮN; có index đúng để giảm
số hàng bị khóa (thiếu index -> InnoDB khóa lan rộng rất nhiều hàng).'
,description_en=
'InnoDB locks at the ROW level, but under REPEATABLE READ (default) it
also locks GAPS to prevent phantoms.

3 LOCK TYPES:
  Record lock  : locks exactly one index row
  Gap lock     : locks the GAP between two index values (blocks inserts)
  Next-key lock: record + gap (default under REPEATABLE READ)

EXAMPLE of locking for a safe update:
  START TRANSACTION;
    SELECT * FROM acc WHERE id = 1 FOR UPDATE;   -- lock row id=1
    UPDATE acc SET bal = bal - 100 WHERE id = 1;
  COMMIT;   -- other transactions touching id=1 WAIT until here

EXAMPLE of a next-key lock preventing phantoms (REPEATABLE READ):
  SELECT * FROM t WHERE age BETWEEN 20 AND 30 FOR UPDATE;
  -- locks rows 20..30 AND the gaps -> another transaction CANNOT insert
  --   age=25 in between -> no phantom

DEADLOCK EXAMPLE (cross-locking order) + handling:
  Session A: UPDATE acc ... WHERE id=1;  then  WHERE id=2;
  Session B: UPDATE acc ... WHERE id=2;  then  WHERE id=1;
  --> InnoDB detects it and rolls back the CHEAPER transaction:
      ERROR 1213 (40001): Deadlock found when trying to get lock
  --> The app should CATCH error 1213 and RETRY the transaction.

AVOID: lock in the SAME order; keep transactions SHORT; have proper
indexes to reduce locked rows (a missing index -> InnoDB locks many rows).'
WHERE id='n_my_locking';

UPDATE kg_nodes SET
description=
'InnoDB mặc định REPEATABLE READ (khác PostgreSQL mặc định READ
COMMITTED). Dùng MVCC qua UNDO LOG + READ VIEW.

4 MỨC:
  READ UNCOMMITTED : cho dirty read (hầu như không dùng)
  READ COMMITTED   : mỗi câu lệnh thấy snapshot mới nhất đã commit
  REPEATABLE READ  : cả transaction dùng CÙNG một read view (chụp ở lần
                     đọc đầu) -> đọc lặp lại nhất quán   [MẶC ĐỊNH]
  SERIALIZABLE     : biến SELECT thành khóa chia sẻ (chặt nhất)

CƠ CHẾ MVCC: khi đọc, InnoDB dựng lại phiên bản hàng khớp read view
bằng cách lần theo UNDO LOG -> người đọc không chặn người ghi.

VÍ DỤ READ COMMITTED vs REPEATABLE READ:
  Session A                          Session B
  ---------                          ---------
  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  START TRANSACTION;
  SELECT bal FROM acc WHERE id=1;    -- 500 (chụp read view tại đây)
                                     UPDATE acc SET bal=800 WHERE id=1;
                                     COMMIT;
  SELECT bal FROM acc WHERE id=1;    -- VẪN 500 (cùng read view)
  COMMIT;
  -- Nếu đổi sang READ COMMITTED: lần đọc thứ 2 sẽ ra 800.

ĐIỂM ĐẶC BIỆT: REPEATABLE READ + gap lock giúp InnoDB chống phantom
trong nhiều trường hợp (khác lý thuyết SQL chuẩn, nơi RR vẫn có phantom).'
,description_en=
'InnoDB defaults to REPEATABLE READ (unlike PostgreSQL, which defaults
to READ COMMITTED). It does MVCC via the UNDO LOG + a READ VIEW.

4 LEVELS:
  READ UNCOMMITTED : allows dirty reads (rarely used)
  READ COMMITTED   : each statement sees the latest committed snapshot
  REPEATABLE READ  : the whole transaction uses the SAME read view (taken
                     at the first read) -> consistent repeated reads [DEFAULT]
  SERIALIZABLE     : turns SELECT into a shared lock (strictest)

MVCC MECHANISM: on read, InnoDB reconstructs the row version matching the
read view by walking the UNDO LOG -> readers do not block writers.

READ COMMITTED vs REPEATABLE READ EXAMPLE:
  Session A                          Session B
  ---------                          ---------
  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  START TRANSACTION;
  SELECT bal FROM acc WHERE id=1;    -- 500 (read view taken here)
                                     UPDATE acc SET bal=800 WHERE id=1;
                                     COMMIT;
  SELECT bal FROM acc WHERE id=1;    -- STILL 500 (same read view)
  COMMIT;
  -- Under READ COMMITTED: the second read would return 800.

NOTABLE: REPEATABLE READ + gap locks let InnoDB prevent phantoms in many
cases (unlike the SQL standard theory, where RR still allows phantoms).'
WHERE id='n_my_isolation';

UPDATE kg_nodes SET
description=
'EXPLAIN cho biết optimizer định thực thi ra sao.

  EXPLAIN SELECT * FROM orders WHERE user_id = 42;

  id  select_type  table   type  key       rows  Extra
  1   SIMPLE       orders  ref   idx_user   5    Using where

Ý NGHĨA CÁC CỘT:
  type  : kiểu truy cập, TỐT -> XẤU:
          system > const > eq_ref > ref > range > index > ALL
          (ALL = full table scan -> cần tránh trên bảng lớn)
  key   : index THỰC SỰ được dùng (NULL = không dùng index nào)
  rows  : ước lượng số hàng phải đọc (càng nhỏ càng tốt)
  Extra : "Using index"     -> covering index (rất tốt, khỏi đọc bảng)
          "Using where"     -> lọc thêm sau khi đọc
          "Using filesort"  -> phải sắp xếp riêng (tốn kém)
          "Using temporary" -> tạo bảng tạm (tốn kém)

MySQL 8 có EXPLAIN ANALYZE (chạy THẬT + thời gian thực tế):
  EXPLAIN ANALYZE SELECT ... ;
  -- ... (actual time=0.1..0.3 rows=5 loops=1) ...

QUY TRÌNH:
  • type=ALL trên bảng lớn    -> thêm index cho cột lọc.
  • Using filesort/temporary  -> thêm index phục vụ ORDER BY / GROUP BY.
  • rows lớn bất thường        -> ANALYZE TABLE để cập nhật thống kê.'
,description_en=
'EXPLAIN shows how the optimizer plans to execute.

  EXPLAIN SELECT * FROM orders WHERE user_id = 42;

  id  select_type  table   type  key       rows  Extra
  1   SIMPLE       orders  ref   idx_user   5    Using where

MEANING OF THE COLUMNS:
  type  : access type, GOOD -> BAD:
          system > const > eq_ref > ref > range > index > ALL
          (ALL = full table scan -> avoid on large tables)
  key   : the index actually used (NULL = no index used)
  rows  : estimated rows to read (smaller is better)
  Extra : "Using index"     -> covering index (great, no table read)
          "Using where"     -> extra filtering after the read
          "Using filesort"  -> a separate sort (expensive)
          "Using temporary" -> a temp table (expensive)

MySQL 8 has EXPLAIN ANALYZE (actually RUNS it + real timing):
  EXPLAIN ANALYZE SELECT ... ;
  -- ... (actual time=0.1..0.3 rows=5 loops=1) ...

PROCESS:
  • type=ALL on a big table  -> add an index on the filter column.
  • Using filesort/temporary -> add an index for ORDER BY / GROUP BY.
  • unusually large rows      -> ANALYZE TABLE to refresh statistics.'
WHERE id='n_my_explain';

UPDATE kg_nodes SET
description=
'Composite index tuân luật TIỀN TỐ TRÁI NHẤT (leftmost prefix). Covering
index chứa ĐỦ cột mà query cần -> đọc xong NGAY ở index, KHÔNG cần về
clustered index (rất nhanh; EXPLAIN báo "Using index").

VÍ DỤ:
  CREATE INDEX idx_uid_status_amt ON orders (user_id, status, amount);

  -- ✓ COVERING (chỉ đọc index, Extra = "Using index"):
  SELECT status, amount FROM orders
   WHERE user_id = 42 AND status = ''paid'';

  -- ✓ Dùng được index (leftmost prefix):
  WHERE user_id = 42
  WHERE user_id = 42 AND status = ''paid''

  -- ✗ KHÔNG dùng tốt (bỏ cột đầu user_id):
  WHERE status = ''paid''
  WHERE amount > 100

THỨ TỰ CỘT (nguyên tắc):
  1. Cột lọc bằng (=) đặt TRƯỚC.
  2. Cột phạm vi (>, <, BETWEEN) đặt SAU (sau một cột range, các cột
     tiếp theo không còn dùng được để tìm kiếm nữa).
  3. Thêm cột trong SELECT vào index -> biến thành covering.

TỐI ƯU ORDER BY:
  -- index (user_id, created_at) phục vụ:
  SELECT * FROM orders WHERE user_id=42 ORDER BY created_at DESC;
  -- KHÔNG cần filesort vì index đã sắp sẵn theo created_at.'
,description_en=
'A composite index follows the LEFTMOST PREFIX rule. A covering index
contains ALL columns the query needs -> the read finishes AT the index,
NO trip to the clustered index (very fast; EXPLAIN shows "Using index").

EXAMPLE:
  CREATE INDEX idx_uid_status_amt ON orders (user_id, status, amount);

  -- OK COVERING (index-only, Extra = "Using index"):
  SELECT status, amount FROM orders
   WHERE user_id = 42 AND status = ''paid'';

  -- OK uses the index (leftmost prefix):
  WHERE user_id = 42
  WHERE user_id = 42 AND status = ''paid''

  -- NO does not use it well (skips the first column user_id):
  WHERE status = ''paid''
  WHERE amount > 100

COLUMN ORDER (rules):
  1. Equality (=) columns go FIRST.
  2. Range columns (>, <, BETWEEN) go LAST (after one range column, the
     following columns can no longer be used for seeking).
  3. Add SELECTed columns to the index -> makes it covering.

ORDER BY OPTIMIZATION:
  -- index (user_id, created_at) serves:
  SELECT * FROM orders WHERE user_id=42 ORDER BY created_at DESC;
  -- NO filesort needed because the index is already ordered by created_at.'
WHERE id='n_my_covering';

UPDATE kg_nodes SET
description=
'MySQL tách rõ 2 tầng: SQL layer (chung) + storage engine (cắm được).

SƠ ĐỒ + vòng đời một query:
  Client
    │ (giao thức MySQL; mỗi kết nối = 1 THREAD)
    ▼
  ┌ SQL Layer (chung mọi engine) ─────────────────┐
  │ 1. Connection / thread                          │
  │ 2. Parser     (phân tích cú pháp SQL)           │
  │ 3. Optimizer  (chọn kế hoạch, chọn index)       │
  │ 4. Executor   (query cache đã bỏ từ MySQL 8)    │
  └─────────────────────────────────────────────────┘
    │ Handler API
    ▼
  ┌ Storage Engine (cắm được) ────────────────────┐
  │ InnoDB (mặc định, transaction) | MyISAM | MEMORY│
  └─────────────────────────────────────────────────┘
    │
    ▼
  file trên đĩa (.ibd với InnoDB)

KHÁC PostgreSQL:
  • MySQL       : ĐA LUỒNG (mỗi kết nối = 1 thread trong 1 process)
                  -> nhẹ hơn khi có nhiều kết nối.
  • PostgreSQL  : đa TIẾN TRÌNH (mỗi kết nối = 1 process).

Dù nhẹ hơn, vẫn nên dùng connection pool ở tầng app (vd pool của mysql2)
để tái dùng kết nối, tránh chi phí bắt tay lặp lại.'
,description_en=
'MySQL clearly separates 2 layers: the SQL layer (shared) + the storage
engine (pluggable).

DIAGRAM + one query lifecycle:
  Client
    │ (MySQL protocol; each connection = 1 THREAD)
    ▼
  ┌ SQL Layer (shared by all engines) ────────────┐
  │ 1. Connection / thread                          │
  │ 2. Parser     (parse the SQL)                   │
  │ 3. Optimizer  (choose the plan, pick indexes)   │
  │ 4. Executor   (query cache removed in MySQL 8)  │
  └─────────────────────────────────────────────────┘
    │ Handler API
    ▼
  ┌ Storage Engine (pluggable) ───────────────────┐
  │ InnoDB (default, transactional) | MyISAM | MEMORY│
  └─────────────────────────────────────────────────┘
    │
    ▼
  files on disk (.ibd for InnoDB)

VERSUS PostgreSQL:
  • MySQL       : MULTI-THREADED (each connection = a thread in one
                  process) -> lighter with many connections.
  • PostgreSQL  : MULTI-PROCESS (each connection = a process).

Even so, use a connection pool in the app (e.g. the mysql2 pool) to
reuse connections and avoid repeated handshake cost.'
WHERE id='n_my_arch';

UPDATE kg_nodes SET
description=
'Nhờ kiến trúc cắm engine, MySQL có nhiều storage engine; 2 cái kinh điển:

  Tiêu chí       | InnoDB (mặc định)  | MyISAM (cũ)
  ---------------|--------------------|--------------------
  Transaction    | Có (ACID)          | KHÔNG
  Khóa           | Mức HÀNG (row)     | Mức BẢNG (table)
  Khóa ngoại     | Có                 | Không
  Crash recovery | Có (redo log)      | Yếu
  Phù hợp        | OLTP, ghi nhiều    | đọc thuần, ít ghi

VÍ DỤ chọn / kiểm tra engine:
  CREATE TABLE t (...) ENGINE=InnoDB;         -- luôn ưu tiên InnoDB
  SHOW TABLE STATUS WHERE Name = ''orders'';   -- xem Engine hiện tại
  ALTER TABLE old_tbl ENGINE=InnoDB;          -- chuyển MyISAM -> InnoDB

TẠI SAO gần như LUÔN dùng InnoDB:
  • Khóa mức BẢNG của MyISAM -> một lệnh ghi khóa cả bảng -> nghẽn nặng
    khi tải cao.
  • MyISAM dễ mất dữ liệu khi crash (không có transaction log bền vững).

Engine khác: MEMORY (bảng trong RAM, mất khi restart), ARCHIVE (nén,
chỉ ghi thêm). MyISAM nay chỉ còn ở hệ thống cũ hoặc bảng chỉ đọc.'
,description_en=
'Thanks to the pluggable-engine design, MySQL has several storage
engines; the two classic ones:

  Criteria       | InnoDB (default)   | MyISAM (legacy)
  ---------------|--------------------|--------------------
  Transactions   | Yes (ACID)         | NO
  Locking        | ROW level          | TABLE level
  Foreign keys   | Yes                | No
  Crash recovery | Yes (redo log)     | Weak
  Best for       | OLTP, write-heavy  | read-only, few writes

CHOOSE / CHECK the engine:
  CREATE TABLE t (...) ENGINE=InnoDB;         -- always prefer InnoDB
  SHOW TABLE STATUS WHERE Name = ''orders'';   -- see the current Engine
  ALTER TABLE old_tbl ENGINE=InnoDB;          -- convert MyISAM -> InnoDB

WHY almost ALWAYS InnoDB:
  • MyISAM TABLE-level locking -> one write locks the whole table ->
    severe contention under load.
  • MyISAM loses data easily on crash (no durable transaction log).

Other engines: MEMORY (RAM tables, lost on restart), ARCHIVE (compressed,
append-only). MyISAM now only remains in legacy or read-only tables.'
WHERE id='n_my_engines';

UPDATE kg_nodes SET
description=
'QUY TRÌNH TỐI ƯU thực dụng:

1) BẬT slow query log để tìm câu chậm:
   SET GLOBAL slow_query_log = ON;
   SET GLOBAL long_query_time = 1;      -- ghi lại câu chạy > 1 giây

2) EXPLAIN xem type / key / rows / Extra (xem node EXPLAIN).

3) THÊM index đúng theo mẫu WHERE / ORDER BY (composite, covering).

4) TRÁNH anti-pattern (kèm cách sửa):

   • N+1 query (truy vấn trong vòng lặp):
       ✗ lặp mỗi user rồi chạy SELECT ... WHERE user_id = ?
       ✓ gộp 1 truy vấn: WHERE user_id IN (...)  hoặc dùng JOIN

   • SELECT * :
       ✗ SELECT * FROM orders
       ✓ SELECT id, amount     -- ít cột -> tận dụng covering index

   • Hàm bọc quanh cột (làm index vô dụng):
       ✗ WHERE DATE(created_at) = ''2026-01-01''
       ✓ WHERE created_at >= ''2026-01-01''
             AND created_at <  ''2026-01-02''

   • Phân trang OFFSET lớn (càng sâu càng chậm):
       ✗ ... ORDER BY id LIMIT 100000, 20
       ✓ keyset: WHERE id > :last_id ORDER BY id LIMIT 20

Đo lại sau MỖI thay đổi. Đừng thêm index tràn lan (index làm chậm ghi
và tốn dung lượng).'
,description_en=
'A practical TUNING workflow:

1) ENABLE the slow query log to find slow statements:
   SET GLOBAL slow_query_log = ON;
   SET GLOBAL long_query_time = 1;      -- log statements running > 1s

2) EXPLAIN to inspect type / key / rows / Extra (see the EXPLAIN node).

3) ADD the right index matching the WHERE / ORDER BY shape (composite,
   covering).

4) AVOID anti-patterns (with fixes):

   • N+1 queries (querying in a loop):
       WRONG loop each user then run SELECT ... WHERE user_id = ?
       RIGHT one query: WHERE user_id IN (...)  or use a JOIN

   • SELECT * :
       WRONG SELECT * FROM orders
       RIGHT SELECT id, amount     -- fewer columns -> enable covering

   • Function wrapped around a column (makes the index useless):
       WRONG WHERE DATE(created_at) = ''2026-01-01''
       RIGHT WHERE created_at >= ''2026-01-01''
                 AND created_at <  ''2026-01-02''

   • Large OFFSET pagination (deeper = slower):
       WRONG ... ORDER BY id LIMIT 100000, 20
       RIGHT keyset: WHERE id > :last_id ORDER BY id LIMIT 20

Measure after EACH change. Do not add indexes everywhere (indexes slow
writes and cost space).'
WHERE id='n_my_optimize';

UPDATE kg_nodes SET
description=
'Replication sao chép dữ liệu từ primary sang replica dựa trên BINLOG
(nhật ký ghi lại mọi thay đổi).

SƠ ĐỒ:
  Primary --(binlog)--> [Replica I/O thread] --> relay log
                                                    │
                                       [Replica SQL thread] áp dụng
                                                    ▼
                                              dữ liệu replica

CHẾ ĐỘ BỀN VỮNG:
  • Async (mặc định) : primary KHÔNG chờ replica -> nhanh, nhưng có thể
    mất dữ liệu nếu primary sập trước khi replica nhận kịp.
  • Semi-sync        : primary chờ ÍT NHẤT 1 replica xác nhận đã NHẬN
    (ghi relay log) -> an toàn hơn, chậm hơn chút.

FORMAT binlog:
  ROW (khuyến nghị) : ghi thay đổi từng HÀNG -> an toàn, chính xác.
  STATEMENT         : ghi câu SQL -> gọn nhưng rủi ro với hàm không xác
                      định (NOW(), RAND()).

DÙNG ĐỂ:
  • Mở rộng ĐỌC: app đọc từ replica, ghi vào primary (read/write split).
  • Backup, và failover (nâng replica lên primary khi primary sập).

LƯU Ý replication lag: replica có thể TRỄ -> tình huống đọc-sau-ghi
(read your own write) nên đọc từ primary hoặc chờ đồng bộ.'
,description_en=
'Replication copies data from a primary to replicas based on the BINLOG
(a log recording every change).

DIAGRAM:
  Primary --(binlog)--> [Replica I/O thread] --> relay log
                                                    │
                                       [Replica SQL thread] applies
                                                    ▼
                                              replica data

DURABILITY MODES:
  • Async (default)  : the primary does NOT wait for a replica -> fast,
    but data may be lost if the primary crashes before the replica catches up.
  • Semi-sync        : the primary waits for AT LEAST 1 replica to
    acknowledge receipt (relay log written) -> safer, slightly slower.

BINLOG FORMAT:
  ROW (recommended) : logs per-ROW changes -> safe, precise.
  STATEMENT         : logs the SQL text -> compact but risky with
                      non-deterministic functions (NOW(), RAND()).

USED FOR:
  • Read scaling: the app reads from replicas, writes to the primary
    (read/write split).
  • Backups, and failover (promote a replica to primary when it dies).

MIND replication lag: a replica may LAG -> for read-your-own-write cases,
read from the primary or wait for sync.'
WHERE id='n_my_replication';

UPDATE kg_nodes SET
description=
'Cả hai đều là RDBMS mạnh; chọn theo nhu cầu.

  Tiêu chí        | PostgreSQL              | MySQL (InnoDB)
  ----------------|-------------------------|----------------------
  Kiến trúc       | đa tiến trình           | đa luồng
  Lưu bảng        | heap + index tách rời   | clustered theo PK
  Isolation mặc   | READ COMMITTED          | REPEATABLE READ
  Kiểu dữ liệu    | rất giàu (JSONB, array, | cơ bản + JSON
                  | range, GIS, custom)     |
  Tính năng SQL   | mạnh (CTE đệ quy, window| đủ dùng (cải thiện
                  | , index nâng cao)       | nhiều ở 8.0)
  Vận hành        | cần VACUUM (dead tuple) | chọn PK tăng dần

KHI NÀO CHỌN (kịch bản cụ thể):
  • Phân tích, truy vấn phức tạp, window, CTE đệ quy      -> PostgreSQL
  • Dữ liệu địa lý (PostGIS), JSONB nặng, kiểu tùy biến   -> PostgreSQL
  • Web app phổ thông, đọc nhiều, đội quen MySQL, hosting -> MySQL
  • Cần khóa ngoại + transaction chuẩn: cả hai đều tốt

Kết: khác biệt chỉ RÕ ở quy mô lớn hoặc yêu cầu đặc thù; đa số dự án
cả hai đều đáp ứng tốt. Điểm chung: đều là SQL/ACID, có MVCC, index,
replication, transaction.'
,description_en=
'Both are powerful RDBMSs; choose by need.

  Criteria        | PostgreSQL              | MySQL (InnoDB)
  ----------------|-------------------------|----------------------
  Architecture    | multi-process           | multi-threaded
  Table storage   | heap + separate index   | clustered by PK
  Default isolation| READ COMMITTED         | REPEATABLE READ
  Data types      | very rich (JSONB, array,| basic + JSON
                  | range, GIS, custom)     |
  SQL features    | strong (recursive CTE,  | sufficient (much
                  | window, advanced index) | improved in 8.0)
  Operations      | needs VACUUM (dead tuples)| use an increasing PK

WHEN TO CHOOSE (concrete scenarios):
  • Analytics, complex queries, window, recursive CTE    -> PostgreSQL
  • Geospatial (PostGIS), heavy JSONB, custom types      -> PostgreSQL
  • Common web app, read-heavy, MySQL-familiar team, hosting -> MySQL
  • Need foreign keys + standard transactions: both are good

Conclusion: differences mainly show at large scale or special needs;
both serve most projects well. In common: SQL/ACID, MVCC, indexes,
replication, transactions.'
WHERE id='n_my_pg_vs_my';



-- ===== ĐÀO SÂU Design Patterns =====
UPDATE kg_nodes SET
description=
'Strategy đóng gói nhiều THUẬT TOÁN thay thế nhau, chọn lúc chạy -> khử
if/else phình to, tuân Open/Closed.

TRƯỚC (if/else phình; thêm hãng phải sửa hàm cũ):
  function shippingCost(order, carrier) {
    if (carrier === "fedex")     return order.weight * 2.0;
    else if (carrier === "ups")  return order.weight * 1.8;
    else if (carrier === "self") return 0;
    // thêm hãng mới -> phải sửa hàm này (vi phạm Open/Closed)
  }

SAU (Strategy — mỗi thuật toán một hàm, tra theo key):
  const strategies = {
    fedex: (o) => o.weight * 2.0,
    ups:   (o) => o.weight * 1.8,
    self:  (o) => 0,
  };
  function shippingCost(order, carrier) {
    const strat = strategies[carrier];
    if (!strat) throw new Error("Unknown carrier: " + carrier);
    return strat(order);
  }

GIẢI THÍCH TỪNG BƯỚC:
  1. Mỗi cách tính = một strategy (hàm/lớp cùng "hình dạng" gọi).
  2. Chọn strategy lúc chạy qua key (carrier).
  3. Thêm hãng mới = THÊM một entry, KHÔNG sửa shippingCost.

ỨNG DỤNG: tính giá/thuế, thuật toán nén, chiến lược retry, xác thực
nhiều kiểu (JWT / OAuth / API key).'
,description_en=
'Strategy encapsulates interchangeable ALGORITHMS chosen at runtime ->
removes bloated if/else, follows Open/Closed.

BEFORE (bloated if/else; adding a carrier edits the old function):
  function shippingCost(order, carrier) {
    if (carrier === "fedex")     return order.weight * 2.0;
    else if (carrier === "ups")  return order.weight * 1.8;
    else if (carrier === "self") return 0;
    // a new carrier -> must edit this function (breaks Open/Closed)
  }

AFTER (Strategy - one function per algorithm, looked up by key):
  const strategies = {
    fedex: (o) => o.weight * 2.0,
    ups:   (o) => o.weight * 1.8,
    self:  (o) => 0,
  };
  function shippingCost(order, carrier) {
    const strat = strategies[carrier];
    if (!strat) throw new Error("Unknown carrier: " + carrier);
    return strat(order);
  }

STEP BY STEP:
  1. Each calculation = a strategy (a function/class with the same call shape).
  2. Pick the strategy at runtime by key (carrier).
  3. A new carrier = ADD an entry, do NOT edit shippingCost.

USES: pricing/tax, compression algorithms, retry strategies, multiple
auth methods (JWT / OAuth / API key).'
WHERE id='n_dp_strategy';

UPDATE kg_nodes SET
description=
'Factory tách việc TẠO object khỏi nơi dùng -> đổi loại object mà không
sửa code gọi.

TRƯỚC (nơi dùng tự new, phụ thuộc lớp cụ thể, logic tạo rải rác):
  let logger;
  if (env === "prod") logger = new CloudLogger(apiKey);
  else                logger = new ConsoleLogger();

SAU (Factory gom việc tạo về một chỗ):
  function createLogger(env) {
    switch (env) {
      case "prod": return new CloudLogger(process.env.LOG_KEY);
      case "file": return new FileLogger("/var/log/app.log");
      default:     return new ConsoleLogger();
    }
  }
  const logger = createLogger(process.env.NODE_ENV);

GIẢI THÍCH TỪNG BƯỚC:
  1. Client chỉ gọi createLogger(), KHÔNG biết lớp cụ thể nào được tạo.
  2. Đổi/thêm loại logger -> chỉ sửa factory, nơi dùng giữ nguyên.
  3. Abstract Factory: tạo cả một HỌ object liên quan (vd theme UI:
     createButton() + createInput() cùng phong cách).

DÙNG KHI: khởi tạo phức tạp, phụ thuộc cấu hình/điều kiện, hoặc muốn
giấu chi tiết lớp cụ thể khỏi client (giảm coupling).'
,description_en=
'A Factory separates object CREATION from its use -> change the object
type without editing the calling code.

BEFORE (callers new directly, depend on concrete classes, scattered logic):
  let logger;
  if (env === "prod") logger = new CloudLogger(apiKey);
  else                logger = new ConsoleLogger();

AFTER (a Factory gathers creation in one place):
  function createLogger(env) {
    switch (env) {
      case "prod": return new CloudLogger(process.env.LOG_KEY);
      case "file": return new FileLogger("/var/log/app.log");
      default:     return new ConsoleLogger();
    }
  }
  const logger = createLogger(process.env.NODE_ENV);

STEP BY STEP:
  1. The client only calls createLogger(), unaware of the concrete class.
  2. Changing/adding a logger type -> edit only the factory; callers stay.
  3. Abstract Factory: create a whole FAMILY of related objects (e.g. a
     UI theme: createButton() + createInput() in one style).

USE WHEN: creation is complex, depends on config/conditions, or you want
to hide concrete classes from the client (reduce coupling).'
WHERE id='n_dp_factory';

UPDATE kg_nodes SET
description=
'Đảm bảo một lớp CHỈ có một instance, chia sẻ toàn cục (connection pool,
config, logger).

CÁCH 1 — trong Node, module cache là singleton TỰ NHIÊN:
  // db.js
  const { Pool } = require("pg");
  const pool = new Pool({ max: 10 });
  module.exports = pool;        // mọi require dùng CHUNG một pool

  // a.js: const pool = require("./db");   -> cùng instance
  // b.js: const pool = require("./db");   -> cùng instance đó

CÁCH 2 — bằng class (lười khởi tạo):
  class Config {
    static #instance;
    static get() {
      if (!Config.#instance) Config.#instance = new Config();
      return Config.#instance;
    }
  }
  const cfg = Config.get();

GIẢI THÍCH & CẢNH BÁO:
  1. Node cache module theo đường dẫn -> export sẵn 1 instance là đủ.
  2. Singleton = GLOBAL STATE -> khó test (khó reset giữa các test), ẩn
     phụ thuộc, dễ tạo coupling ngầm.
  3. Nhiều trường hợp NÊN dùng Dependency Injection (truyền pool/config
     vào) thay vì singleton cứng -> dễ mock, dễ thay thế khi test.'
,description_en=
'Ensures a class has only one instance, shared globally (connection pool,
config, logger).

WAY 1 - in Node, the module cache is a NATURAL singleton:
  // db.js
  const { Pool } = require("pg");
  const pool = new Pool({ max: 10 });
  module.exports = pool;        // every require shares the SAME pool

  // a.js: const pool = require("./db");   -> same instance
  // b.js: const pool = require("./db");   -> that same instance

WAY 2 - via a class (lazy init):
  class Config {
    static #instance;
    static get() {
      if (!Config.#instance) Config.#instance = new Config();
      return Config.#instance;
    }
  }
  const cfg = Config.get();

EXPLANATION & WARNING:
  1. Node caches modules by path -> exporting one instance is enough.
  2. A singleton = GLOBAL STATE -> hard to test (hard to reset between
     tests), hides dependencies, encourages hidden coupling.
  3. Often prefer Dependency Injection (pass the pool/config in) over a
     hard singleton -> easy to mock and swap in tests.'
WHERE id='n_dp_singleton';

UPDATE kg_nodes SET
description=
'Observer: khi subject đổi trạng thái, nó tự động THÔNG BÁO các observer
đã đăng ký. Nền của lập trình event-driven.

TRƯỚC (gọi trực tiếp -> coupling chặt, thêm việc phải sửa hàm):
  function registerUser(u) {
    saveUser(u);
    sendWelcomeEmail(u);   // hàm đăng ký phải BIẾT mọi việc phụ
    createAuditLog(u);     // thêm việc -> lại sửa hàm này
    addToCrm(u);
  }

SAU (Observer -> subject không cần biết ai đang nghe):
  const { EventEmitter } = require("events");
  const bus = new EventEmitter();

  bus.on("userRegistered", (u) => sendWelcomeEmail(u));
  bus.on("userRegistered", (u) => createAuditLog(u));
  bus.on("userRegistered", (u) => addToCrm(u));

  function registerUser(u) {
    saveUser(u);
    bus.emit("userRegistered", u);   // chỉ phát sự kiện
  }

GIẢI THÍCH TỪNG BƯỚC:
  1. Subject (registerUser) chỉ EMIT sự kiện, không biết có bao nhiêu
     observer đang nghe.
  2. Thêm phản ứng mới = THÊM một listener, KHÔNG sửa registerUser.
  3. emit là ĐỒNG BỘ trong Node -> observer nặng nên đẩy sang hàng đợi.

XUẤT HIỆN Ở: EventEmitter, RxJS, reactivity của Vue, addEventListener
của DOM, message bus trong microservices.'
,description_en=
'Observer: when a subject changes state, it automatically NOTIFIES its
registered observers. The basis of event-driven programming.

BEFORE (direct calls -> tight coupling; adding work edits the function):
  function registerUser(u) {
    saveUser(u);
    sendWelcomeEmail(u);   // the register function must KNOW every side task
    createAuditLog(u);     // adding a task -> edit this function again
    addToCrm(u);
  }

AFTER (Observer -> the subject need not know who listens):
  const { EventEmitter } = require("events");
  const bus = new EventEmitter();

  bus.on("userRegistered", (u) => sendWelcomeEmail(u));
  bus.on("userRegistered", (u) => createAuditLog(u));
  bus.on("userRegistered", (u) => addToCrm(u));

  function registerUser(u) {
    saveUser(u);
    bus.emit("userRegistered", u);   // just emit an event
  }

STEP BY STEP:
  1. The subject (registerUser) only EMITs; it does not know how many
     observers listen.
  2. A new reaction = ADD a listener, do NOT edit registerUser.
  3. emit is SYNCHRONOUS in Node -> push heavy observers to a queue.

APPEARS IN: EventEmitter, RxJS, Vue reactivity, DOM addEventListener,
the message bus in microservices.'
WHERE id='n_dp_observer';

UPDATE kg_nodes SET
description=
'Adapter là CẦU NỐI giữa 2 interface không tương thích — bọc API cũ/bên
thứ ba thành interface mà app mong đợi.

BỐI CẢNH: app định nghĩa interface thanh toán chuẩn:
  async function checkout(gateway, amount) {
    return gateway.pay(amount);   // app chỉ biết .pay()
  }

VẤN ĐỀ: Stripe có API KHÁC (charges.create, đơn vị cent USD).

ADAPTER bọc Stripe về interface chuẩn:
  class StripeAdapter {
    constructor(stripe) { this.stripe = stripe; }
    async pay(amountVnd) {
      const usdCents = Math.round(amountVnd / 25000 * 100);
      const res = await this.stripe.charges.create({
        amount: usdCents, currency: "usd",
      });
      return { id: res.id, ok: res.status === "succeeded" };
    }
  }
  await checkout(new StripeAdapter(stripe), 500000);

GIẢI THÍCH TỪNG BƯỚC:
  1. App phụ thuộc INTERFACE (.pay), không phụ thuộc Stripe cụ thể.
  2. Adapter dịch: tên hàm, đơn vị tiền, định dạng kết quả.
  3. Đổi sang PayPal -> viết PaypalAdapter, checkout() KHÔNG đổi.

DÙNG KHI: tích hợp thư viện/bên thứ ba có API không khớp với app.'
,description_en=
'An Adapter is a BRIDGE between two incompatible interfaces - it wraps a
legacy/third-party API into the interface your app expects.

CONTEXT: the app defines a standard payment interface:
  async function checkout(gateway, amount) {
    return gateway.pay(amount);   // the app only knows .pay()
  }

PROBLEM: Stripe has a DIFFERENT API (charges.create, USD cents).

ADAPTER wraps Stripe into the standard interface:
  class StripeAdapter {
    constructor(stripe) { this.stripe = stripe; }
    async pay(amountVnd) {
      const usdCents = Math.round(amountVnd / 25000 * 100);
      const res = await this.stripe.charges.create({
        amount: usdCents, currency: "usd",
      });
      return { id: res.id, ok: res.status === "succeeded" };
    }
  }
  await checkout(new StripeAdapter(stripe), 500000);

STEP BY STEP:
  1. The app depends on the INTERFACE (.pay), not on Stripe specifically.
  2. The adapter translates: method name, currency unit, result shape.
  3. Switching to PayPal -> write a PaypalAdapter, checkout() is UNCHANGED.

USE WHEN: integrating a library/third party whose API does not match the app.'
WHERE id='n_dp_adapter';

UPDATE kg_nodes SET
description=
'Decorator THÊM hành vi cho object/hàm mà không sửa gốc, bằng cách BỌC
nó; có thể ghép nhiều lớp bọc.

VÍ DỤ bọc hàm bằng logging + cache (ghép chồng):
  const withLogging = (fn) => async (...args) => {
    console.log("call", fn.name, args);
    const r = await fn(...args);
    console.log("->", r);
    return r;
  };
  const withCache = (fn) => {
    const cache = new Map();
    return async (key) => {
      if (cache.has(key)) return cache.get(key);   // hit
      const r = await fn(key);
      cache.set(key, r);
      return r;
    };
  };

  // ghép: logging(cache(fetchUser))
  const smartFetch = withLogging(withCache(fetchUser));
  await smartFetch(42);   // lần 1: chạy thật + log
  await smartFetch(42);   // lần 2: lấy từ cache + log

GIẢI THÍCH TỪNG BƯỚC:
  1. Mỗi decorator nhận fn, trả về fn MỚI cùng chữ ký -> ghép được.
  2. Thứ tự bọc = thứ tự chạy (ngoài vào trong).
  3. KHÔNG sửa fetchUser gốc -> tuân Open/Closed.

ỨNG DỤNG: middleware Express, TypeScript @Decorator (@Injectable),
higher-order function/component. Khác Proxy (kiểm soát truy cập),
Decorator THÊM tính năng.'
,description_en=
'A Decorator ADDS behavior to an object/function without modifying the
original, by WRAPPING it; multiple wrappers can be composed.

EXAMPLE wrapping a function with logging + cache (stacked):
  const withLogging = (fn) => async (...args) => {
    console.log("call", fn.name, args);
    const r = await fn(...args);
    console.log("->", r);
    return r;
  };
  const withCache = (fn) => {
    const cache = new Map();
    return async (key) => {
      if (cache.has(key)) return cache.get(key);   // hit
      const r = await fn(key);
      cache.set(key, r);
      return r;
    };
  };

  // compose: logging(cache(fetchUser))
  const smartFetch = withLogging(withCache(fetchUser));
  await smartFetch(42);   // 1st: runs for real + logs
  await smartFetch(42);   // 2nd: from cache + logs

STEP BY STEP:
  1. Each decorator takes fn and returns a NEW fn with the same signature
     -> composable.
  2. Wrapping order = execution order (outside in).
  3. It does NOT modify the original fetchUser -> follows Open/Closed.

USES: Express middleware, TypeScript @Decorator (@Injectable),
higher-order functions/components. Unlike Proxy (access control), a
Decorator ADDS features.'
WHERE id='n_dp_decorator';

UPDATE kg_nodes SET
description=
'Facade cung cấp MỘT interface đơn giản che giấu một hệ thống con phức
tạp (nhiều lớp/bước).

TRƯỚC (client phải biết và gọi đúng thứ tự nhiều bước):
  const raw   = decoder.decode(file);
  const small = resizer.resize(raw, 720);
  const enc   = encoder.encode(small, "h264");
  const url   = uploader.upload(enc);
  // client gánh toàn bộ chi tiết + thứ tự các bước

SAU (Facade gói lại sau một hàm):
  class MediaService {
    constructor(decoder, resizer, encoder, uploader) {
      Object.assign(this, { decoder, resizer, encoder, uploader });
    }
    async process(file) {
      const raw   = this.decoder.decode(file);
      const small = this.resizer.resize(raw, 720);
      const enc   = this.encoder.encode(small, "h264");
      return this.uploader.upload(enc);
    }
  }
  const url = await media.process(file);   // client chỉ gọi 1 hàm

GIẢI THÍCH TỪNG BƯỚC:
  1. Facade giấu độ phức tạp và thứ tự các bước bên trong.
  2. Client chỉ phụ thuộc MediaService, không phụ thuộc 4 module con
     -> đổi bên trong không ảnh hưởng client.
  3. Khác Adapter (đổi interface cho tương thích): Facade chỉ ĐƠN GIẢN HÓA.

VÍ DỤ THỰC TẾ: một SDK bọc nhiều API con; service layer gói nhiều
repository.'
,description_en=
'A Facade provides ONE simple interface hiding a complex subsystem (many
classes/steps).

BEFORE (the client must know and call many steps in the right order):
  const raw   = decoder.decode(file);
  const small = resizer.resize(raw, 720);
  const enc   = encoder.encode(small, "h264");
  const url   = uploader.upload(enc);
  // the client carries all the detail + step order

AFTER (a Facade wraps it behind one method):
  class MediaService {
    constructor(decoder, resizer, encoder, uploader) {
      Object.assign(this, { decoder, resizer, encoder, uploader });
    }
    async process(file) {
      const raw   = this.decoder.decode(file);
      const small = this.resizer.resize(raw, 720);
      const enc   = this.encoder.encode(small, "h264");
      return this.uploader.upload(enc);
    }
  }
  const url = await media.process(file);   // the client calls one method

STEP BY STEP:
  1. The facade hides the complexity and step order inside.
  2. The client depends only on MediaService, not the 4 submodules ->
     internal changes do not affect the client.
  3. Unlike Adapter (changes an interface for compatibility): a Facade
     just SIMPLIFIES.

REAL EXAMPLE: an SDK wrapping many sub-APIs; a service layer wrapping
several repositories.'
WHERE id='n_dp_facade';

UPDATE kg_nodes SET
description=
'Proxy đứng THAY object thật (cùng interface) để KIỂM SOÁT truy cập:
lazy load, cache, kiểm quyền, logging.

VÍ DỤ 1 — JS Proxy chặn field nhạy cảm + log đọc:
  const user = { name: "An", ssn: "123-45-6789" };
  const guarded = new Proxy(user, {
    get(target, key) {
      if (key === "ssn") throw new Error("Access denied: ssn");
      console.log("read", key);
      return target[key];
    },
  });
  guarded.name;   // log "read name" -> "An"
  guarded.ssn;    // ném lỗi Access denied

VÍ DỤ 2 — Virtual proxy (tạo object nặng KHI CẦN):
  class ReportProxy {
    #real;
    render() {
      if (!this.#real) this.#real = new HeavyReport();  // lazy
      return this.#real.render();
    }
  }

GIẢI THÍCH TỪNG BƯỚC:
  1. Proxy CÙNG interface với object thật -> client không phân biệt.
  2. Thêm lớp kiểm soát: quyền (protection), tạo lười (virtual), cache,
     gọi từ xa (remote proxy).
  3. Khác Decorator (thêm tính năng): Proxy tập trung KIỂM SOÁT truy cập.'
,description_en=
'A Proxy stands IN FOR the real object (same interface) to CONTROL access:
lazy loading, caching, permission checks, logging.

EXAMPLE 1 - a JS Proxy blocking a sensitive field + logging reads:
  const user = { name: "An", ssn: "123-45-6789" };
  const guarded = new Proxy(user, {
    get(target, key) {
      if (key === "ssn") throw new Error("Access denied: ssn");
      console.log("read", key);
      return target[key];
    },
  });
  guarded.name;   // logs "read name" -> "An"
  guarded.ssn;    // throws Access denied

EXAMPLE 2 - a Virtual proxy (create a heavy object ON DEMAND):
  class ReportProxy {
    #real;
    render() {
      if (!this.#real) this.#real = new HeavyReport();  // lazy
      return this.#real.render();
    }
  }

STEP BY STEP:
  1. The proxy has the SAME interface as the real object -> the client
     cannot tell the difference.
  2. Add a control layer: protection (permissions), virtual (lazy),
     caching, remote (remote proxy).
  3. Unlike Decorator (adds features): a Proxy focuses on CONTROLLING access.'
WHERE id='n_dp_proxy';

UPDATE kg_nodes SET
description=
'Builder dựng object phức tạp theo TỪNG BƯỚC, tránh constructor nhiều
tham số khó nhớ.

TRƯỚC (constructor dài, dễ nhầm thứ tự/nghĩa tham số):
  new Query("users", ["id","name"], "age>18", null, "name", 10);
  // tham số null + thứ tự -> khó đọc, dễ sai

SAU (Builder fluent — nối chuỗi, rõ nghĩa):
  class QueryBuilder {
    #p = { cols: ["*"], where: [], order: null, limit: null };
    select(...c) { this.#p.cols = c;  return this; }
    from(t)      { this.#p.table = t; return this; }
    where(w)     { this.#p.where.push(w); return this; }
    orderBy(o)   { this.#p.order = o; return this; }
    limit(n)     { this.#p.limit = n; return this; }
    build() {
      let q = `SELECT ${this.#p.cols.join(",")} FROM ${this.#p.table}`;
      if (this.#p.where.length) q += " WHERE " + this.#p.where.join(" AND ");
      if (this.#p.order) q += " ORDER BY " + this.#p.order;
      if (this.#p.limit) q += " LIMIT " + this.#p.limit;
      return q;
    }
  }
  const sql = new QueryBuilder()
    .select("id","name").from("users").where("age>18")
    .orderBy("name").limit(10).build();

GIẢI THÍCH TỪNG BƯỚC:
  1. Mỗi bước trả về this -> nối chuỗi được (fluent).
  2. build() ráp kết quả cuối cùng.
  3. Bỏ qua bước không cần (where/limit tùy chọn) -> linh hoạt.

DÙNG KHI: object nhiều tùy chọn KHÔNG bắt buộc (query builder, HTTP
request builder, cấu hình phức tạp).'
,description_en=
'A Builder constructs a complex object STEP BY STEP, avoiding a
constructor with too many hard-to-remember parameters.

BEFORE (a long constructor, easy to mix up order/meaning):
  new Query("users", ["id","name"], "age>18", null, "name", 10);
  // null args + positional order -> unreadable, error-prone

AFTER (a fluent Builder - chained, self-describing):
  class QueryBuilder {
    #p = { cols: ["*"], where: [], order: null, limit: null };
    select(...c) { this.#p.cols = c;  return this; }
    from(t)      { this.#p.table = t; return this; }
    where(w)     { this.#p.where.push(w); return this; }
    orderBy(o)   { this.#p.order = o; return this; }
    limit(n)     { this.#p.limit = n; return this; }
    build() {
      let q = `SELECT ${this.#p.cols.join(",")} FROM ${this.#p.table}`;
      if (this.#p.where.length) q += " WHERE " + this.#p.where.join(" AND ");
      if (this.#p.order) q += " ORDER BY " + this.#p.order;
      if (this.#p.limit) q += " LIMIT " + this.#p.limit;
      return q;
    }
  }
  const sql = new QueryBuilder()
    .select("id","name").from("users").where("age>18")
    .orderBy("name").limit(10).build();

STEP BY STEP:
  1. Each step returns this -> chainable (fluent).
  2. build() assembles the final result.
  3. Skip unneeded steps (where/limit optional) -> flexible.

USE WHEN: an object has many OPTIONAL settings (query builder, HTTP
request builder, complex config).'
WHERE id='n_dp_builder';

UPDATE kg_nodes SET
description=
'Command đóng gói một YÊU CẦU thành object -> cho phép hàng đợi, hoàn
tác (undo), log, retry.

VÍ DỤ giỏ hàng có undo:
  class AddItemCommand {
    constructor(cart, item) { this.cart = cart; this.item = item; }
    execute() { this.cart.add(this.item); }
    undo()    { this.cart.remove(this.item); }
  }

  const history = [];
  function run(cmd)   { cmd.execute(); history.push(cmd); }
  function undoLast() { const c = history.pop(); if (c) c.undo(); }

  run(new AddItemCommand(cart, phone));   // thêm phone
  run(new AddItemCommand(cart, cover));   // thêm cover
  undoLast();                             // bỏ cover (gọi undo)

GIẢI THÍCH TỪNG BƯỚC:
  1. Mỗi hành động = một object có execute() và undo().
  2. Lưu history -> undo/redo dễ dàng.
  3. Vì là OBJECT -> có thể đẩy vào job queue, serialize để chạy sau, retry.

ỨNG DỤNG: job queue (BullMQ), undo/redo trong editor, transaction
script, ghi log lệnh (hướng event sourcing).'
,description_en=
'Command encapsulates a REQUEST as an object -> enabling queuing, undo,
logging, and retry.

SHOPPING-CART EXAMPLE with undo:
  class AddItemCommand {
    constructor(cart, item) { this.cart = cart; this.item = item; }
    execute() { this.cart.add(this.item); }
    undo()    { this.cart.remove(this.item); }
  }

  const history = [];
  function run(cmd)   { cmd.execute(); history.push(cmd); }
  function undoLast() { const c = history.pop(); if (c) c.undo(); }

  run(new AddItemCommand(cart, phone));   // add phone
  run(new AddItemCommand(cart, cover));   // add cover
  undoLast();                             // remove cover (calls undo)

STEP BY STEP:
  1. Each action = an object with execute() and undo().
  2. Keep a history -> easy undo/redo.
  3. Because it is an OBJECT -> you can push it to a job queue, serialize
     it to run later, or retry it.

USES: job queues (BullMQ), editor undo/redo, transaction scripts,
command logging (toward event sourcing).'
WHERE id='n_dp_command';

UPDATE kg_nodes SET
description=
'Design pattern là giải pháp MẪU cho vấn đề thiết kế lặp lại — cách tổ
chức code, không phải thư viện copy-paste. Gang of Four (GoF) chia 23
pattern thành 3 nhóm:

  • Creational : cách TẠO object
      Singleton, Factory, Builder, Prototype, Abstract Factory
  • Structural : cách GHÉP object/lớp
      Adapter, Decorator, Facade, Proxy, Composite, Bridge
  • Behavioral : cách object TƯƠNG TÁC
      Strategy, Observer, Command, Template Method, State, Iterator

MỖI NHÓM GIẢI QUYẾT MỘT LOẠI VẤN ĐỀ:
  - Khởi tạo phức tạp / tốn kém          -> Creational
  - Kết nối/mở rộng cấu trúc mà ít sửa   -> Structural
  - Nhiều nhánh if/else theo hành vi     -> Behavioral

LỢI ÍCH: dễ mở rộng, giảm phụ thuộc, dễ test, và tạo NGÔN NGỮ CHUNG
(nói "dùng Strategy ở đây" là cả đội hiểu ngay).

QUAN TRỌNG — đừng lạm dụng: pattern là công cụ cho vấn đề CỤ THỂ. Nhồi
pattern vào chỗ đơn giản = over-engineering, code khó đọc hơn. Chỉ áp
khi vấn đề thực sự xuất hiện (code lặp, khó đổi, khó test).'
,description_en=
'A design pattern is a TEMPLATE solution to recurring design problems -
a way to organize code, not a copy-paste library. The Gang of Four
(GoF) groups 23 patterns into 3 categories:

  • Creational : how to CREATE objects
      Singleton, Factory, Builder, Prototype, Abstract Factory
  • Structural : how to COMPOSE objects/classes
      Adapter, Decorator, Facade, Proxy, Composite, Bridge
  • Behavioral : how objects INTERACT
      Strategy, Observer, Command, Template Method, State, Iterator

EACH GROUP SOLVES ONE KIND OF PROBLEM:
  - Complex / expensive creation         -> Creational
  - Connect/extend structure with little edits -> Structural
  - Many behavior-based if/else branches -> Behavioral

BENEFITS: easier to extend, less coupling, easier to test, and a SHARED
VOCABULARY (saying "use Strategy here" is instantly understood).

IMPORTANT - do not overuse: a pattern is a tool for a SPECIFIC problem.
Forcing patterns into simple code = over-engineering, harder to read.
Apply only when the problem actually appears (duplication, hard to
change, hard to test).'
WHERE id='n_dp_intro';

UPDATE kg_nodes SET
description=
'Vài pattern ngoài GoF, rất phổ biến trong Node/backend, kèm ví dụ:

REPOSITORY — tách truy cập dữ liệu khỏi business logic:
  class UserRepo {
    constructor(db) { this.db = db; }
    findById(id) { return this.db.query("SELECT * FROM users WHERE id=$1", [id]); }
    save(u)      { return this.db.query("INSERT ..."); }
  }
  // service dùng repo, KHÔNG biết là SQL hay Mongo -> dễ đổi/test

DEPENDENCY INJECTION — truyền phụ thuộc từ ngoài vào:
  class UserService {
    constructor(userRepo, mailer) {   // inject, KHÔNG tự new bên trong
      this.userRepo = userRepo;
      this.mailer = mailer;
    }
  }
  // test: inject repo/mailer GIẢ (mock) -> test không cần DB thật.
  // Đây là nền của NestJS (DI container).

MIDDLEWARE / CHAIN OF RESPONSIBILITY — xử lý request qua chuỗi:
  app.use(auth);       // -> next()
  app.use(logger);     // -> next()
  app.use(validate);   // -> handler
  // mỗi middleware làm một việc rồi gọi next().

DTO — object định dạng dữ liệu vào/ra, tách khỏi entity DB.

Những pattern này giải quyết: tách lớp, dễ test, dễ bảo trì — quan
trọng hơn việc thuộc lòng đủ 23 GoF.'
,description_en=
'A few patterns beyond GoF, very common in Node/backend, with examples:

REPOSITORY - separates data access from business logic:
  class UserRepo {
    constructor(db) { this.db = db; }
    findById(id) { return this.db.query("SELECT * FROM users WHERE id=$1", [id]); }
    save(u)      { return this.db.query("INSERT ..."); }
  }
  // the service uses repo, unaware it is SQL or Mongo -> easy swap/test

DEPENDENCY INJECTION - pass dependencies in from outside:
  class UserService {
    constructor(userRepo, mailer) {   // injected, NOT newed inside
      this.userRepo = userRepo;
      this.mailer = mailer;
    }
  }
  // test: inject FAKE repo/mailer (mocks) -> no real DB needed.
  // This is the basis of NestJS (a DI container).

MIDDLEWARE / CHAIN OF RESPONSIBILITY - process a request via a chain:
  app.use(auth);       // -> next()
  app.use(logger);     // -> next()
  app.use(validate);   // -> handler
  // each middleware does one thing then calls next().

DTO - an object shaping input/output data, separate from the DB entity.

These solve: layering, testability, maintainability - more important
than memorizing all 23 GoF patterns.'
WHERE id='n_dp_backend';


-- ĐÀO SÂU Design Patterns (đợt 3d): SOLID
UPDATE kg_nodes SET
description=
'SOLID — 5 nguyên lý thiết kế hướng đối tượng, nền của nhiều design pattern:

S — Single Responsibility: một lớp chỉ MỘT lý do để thay đổi.
    ✗ class User { save(); sendEmail(); renderHtml(); }  // 3 trách nhiệm
    ✓ tách riêng: User (dữ liệu), UserRepo (lưu), Mailer (email), View.

O — Open/Closed: mở để MỞ RỘNG, đóng để SỬA ĐỔI.
    ✗ if/else theo loại -> thêm loại phải sửa hàm cũ
    ✓ Strategy: thêm loại = thêm một class/hàm, KHÔNG sửa code cũ.

L — Liskov Substitution: lớp con phải thay được lớp cha mà không phá hành vi.
    ✗ class Square extends Rectangle (setWidth đổi luôn height)
       -> phá kỳ vọng của code đang dùng Rectangle.

I — Interface Segregation: nhiều interface NHỎ, chuyên biệt hơn một cái to.
    ✗ interface Worker { work(); eat(); }   // Robot đâu cần eat()
    ✓ tách Workable, Eatable riêng.

D — Dependency Inversion: phụ thuộc ABSTRACTION, không phụ thuộc chi tiết.
    class OrderService {
      constructor(repo) { this.repo = repo; }  // repo là một interface
    }
    // đổi Postgres/Mongo KHÔNG sửa OrderService; dễ mock khi test.

SOLID giúp code dễ mở rộng, dễ test, ít vỡ khi thay đổi. Rất nhiều
design pattern chính là cách HIỆN THỰC các nguyên lý này.'
,description_en=
'SOLID - 5 object-oriented design principles, the basis of many patterns:

S - Single Responsibility: a class has only ONE reason to change.
    WRONG class User { save(); sendEmail(); renderHtml(); }  // 3 duties
    RIGHT split: User (data), UserRepo (persist), Mailer (email), View.

O - Open/Closed: open to EXTENSION, closed to MODIFICATION.
    WRONG if/else by type -> a new type edits the old function
    RIGHT Strategy: a new type = a new class/function, NO edit to old code.

L - Liskov Substitution: a subclass must substitute its base without breaking behavior.
    WRONG class Square extends Rectangle (setWidth also changes height)
       -> breaks the expectations of code using Rectangle.

I - Interface Segregation: many SMALL, specific interfaces beat one large one.
    WRONG interface Worker { work(); eat(); }   // a Robot does not eat()
    RIGHT split Workable, Eatable.

D - Dependency Inversion: depend on ABSTRACTIONS, not on details.
    class OrderService {
      constructor(repo) { this.repo = repo; }  // repo is an interface
    }
    // swap Postgres/Mongo WITHOUT editing OrderService; easy to mock in tests.

SOLID makes code easier to extend and test, and less brittle to change.
Many design patterns are exactly ways to IMPLEMENT these principles.'
WHERE id='n_dp_solid';

-- ĐÀO SÂU Microservices (đợt 3e): Saga, Outbox, Async, Circuit breaker
UPDATE kg_nodes SET
description=
'Không có transaction ACID xuyên nhiều DB service. Saga = chuỗi
transaction cục bộ; mỗi bước phát event; nếu một bước LỖI -> chạy bước
BÙ TRỪ (compensating) để hoàn tác các bước trước.

SƠ ĐỒ (đặt hàng):
  Order created
    ├─► Payment: charge      ── lỗi ─► Cancel Order       (bù)
    ├─► Inventory: reserve   ── lỗi ─► Refund Payment      (bù)
    └─► Shipping: create     ── lỗi ─► Release Inventory   (bù)

VÍ DỤ ORCHESTRATION (mã giả — chạy bù theo thứ tự NGƯỢC):
  async function placeOrderSaga(order) {
    const done = [];
    try {
      await payment.charge(order);     done.push("payment");
      await inventory.reserve(order);  done.push("inventory");
      await shipping.create(order);    done.push("shipping");
    } catch (e) {
      if (done.includes("inventory")) await inventory.release(order);
      if (done.includes("payment"))   await payment.refund(order);
      throw e;   // saga thất bại nhưng đã hoàn tác sạch
    }
  }

GIẢI THÍCH TỪNG BƯỚC:
  1. Mỗi bước là transaction cục bộ ở một service (DB riêng).
  2. Lỗi ở bước n -> hoàn tác n-1 ... 1 bằng hành động bù.
  3. Bù phải IDEMPOTENT (chạy lại không hại) vì có thể bị retry.

HAI KIỂU ĐIỀU PHỐI:
  • Choreography  : service tự nghe event của nhau, KHÔNG trung tâm
    (đơn giản, dễ rối khi nhiều bước).
  • Orchestration : một orchestrator điều khiển trình tự (dễ theo dõi).

Đánh đổi: chỉ nhất quán CUỐI CÙNG; phải thiết kế kỹ các bước bù.'
,description_en=
'There is no ACID transaction across multiple service DBs. A Saga = a
sequence of local transactions; each step emits an event; if a step
FAILS -> run COMPENSATING steps to undo the previous ones.

DIAGRAM (order placement):
  Order created
    ├─► Payment: charge      ── fail ─► Cancel Order        (compensate)
    ├─► Inventory: reserve   ── fail ─► Refund Payment        (compensate)
    └─► Shipping: create     ── fail ─► Release Inventory     (compensate)

ORCHESTRATION EXAMPLE (pseudo-code - compensate in REVERSE order):
  async function placeOrderSaga(order) {
    const done = [];
    try {
      await payment.charge(order);     done.push("payment");
      await inventory.reserve(order);  done.push("inventory");
      await shipping.create(order);    done.push("shipping");
    } catch (e) {
      if (done.includes("inventory")) await inventory.release(order);
      if (done.includes("payment"))   await payment.refund(order);
      throw e;   // saga failed but rolled back cleanly
    }
  }

STEP BY STEP:
  1. Each step is a local transaction in one service (its own DB).
  2. A failure at step n -> undo n-1 ... 1 via compensating actions.
  3. Compensation must be IDEMPOTENT (harmless to re-run) since it may retry.

TWO COORDINATION STYLES:
  • Choreography  : services listen to each other events, NO central
    controller (simple, tangled with many steps).
  • Orchestration : a single orchestrator drives the sequence (easy to follow).

Trade-off: only EVENTUAL consistency; design compensating steps carefully.'
WHERE id='n_ms_saga';

UPDATE kg_nodes SET
description=
'Vấn đề DUAL WRITE: một thao tác cần GHI DB và PHÁT message. Nếu ghi DB
xong nhưng gửi message lỗi (hoặc ngược lại) -> hai bên lệch nhau, mất event.

GIẢI PHÁP OUTBOX: ghi bản ghi nghiệp vụ VÀ một dòng outbox trong CÙNG
một transaction DB (nguyên tử). Một tiến trình relay đọc outbox rồi phát.

BƯỚC 1 — ghi nguyên tử (cùng transaction):
  BEGIN;
    INSERT INTO orders (id, ...) VALUES (...);
    INSERT INTO outbox (id, topic, payload, sent)
      VALUES (gen_random_uuid(), ''order.created'', ''{...}'', false);
  COMMIT;

BƯỚC 2 — relay (worker riêng) đọc & phát:
  const rows = await db.query(
    "SELECT * FROM outbox WHERE sent=false ORDER BY created_at LIMIT 100");
  for (const r of rows) {
    await broker.publish(r.topic, r.payload);            // phát message
    await db.query("UPDATE outbox SET sent=true WHERE id=$1", [r.id]);
  }

GIẢI THÍCH TỪNG BƯỚC:
  1. Ghi orders + outbox CÙNG transaction -> KHÔNG bao giờ lệch nhau.
  2. Relay đảm bảo giao ÍT NHẤT MỘT LẦN (at-least-once).
  3. Vì có thể gửi TRÙNG -> consumer phải IDEMPOTENT (khử trùng theo
     message id đã xử lý).

Đây là cách chuẩn để ghép DB + messaging đáng tin cậy (thay cho dual write).'
,description_en=
'The DUAL WRITE problem: an operation must WRITE to the DB and PUBLISH a
message. If the DB write succeeds but the publish fails (or vice versa)
-> the two diverge and events are lost.

OUTBOX SOLUTION: write the business record AND an outbox row in the SAME
DB transaction (atomic). A relay process reads the outbox then publishes.

STEP 1 - atomic write (same transaction):
  BEGIN;
    INSERT INTO orders (id, ...) VALUES (...);
    INSERT INTO outbox (id, topic, payload, sent)
      VALUES (gen_random_uuid(), ''order.created'', ''{...}'', false);
  COMMIT;

STEP 2 - a relay (separate worker) reads & publishes:
  const rows = await db.query(
    "SELECT * FROM outbox WHERE sent=false ORDER BY created_at LIMIT 100");
  for (const r of rows) {
    await broker.publish(r.topic, r.payload);            // publish
    await db.query("UPDATE outbox SET sent=true WHERE id=$1", [r.id]);
  }

STEP BY STEP:
  1. Writing orders + outbox in the SAME transaction -> they never diverge.
  2. The relay guarantees AT-LEAST-ONCE delivery.
  3. Because it may publish DUPLICATES -> consumers must be IDEMPOTENT
     (dedupe by processed message id).

This is the standard way to combine DB + messaging reliably (instead of
dual write).'
WHERE id='n_ms_outbox';

UPDATE kg_nodes SET
description=
'Service giao tiếp qua MESSAGE BROKER, không chờ nhau trực tiếp -> giảm
ghép nối, chịu lỗi tốt hơn.

  Producer ─► [ Broker: Kafka / RabbitMQ / SQS ] ─► Consumer(s)

VÍ DỤ (RabbitMQ, amqplib):
  // Producer
  const ch = await conn.createChannel();
  await ch.assertQueue("order.created");
  ch.sendToQueue("order.created", Buffer.from(JSON.stringify(order)));

  // Consumer
  await ch.consume("order.created", (msg) => {
    const order = JSON.parse(msg.content.toString());
    sendEmail(order);
    ch.ack(msg);            // xác nhận đã xử lý xong
  });

HAI KIỂU:
  • Message queue (điểm-điểm): mỗi message tới ĐÚNG một consumer
    (giao việc nền: gửi email, resize ảnh).
  • Pub/Sub event: một event, NHIỀU service cùng nghe (OrderPlaced ->
    Inventory, Email, Analytics đều phản ứng).

GIẢI THÍCH TỪNG BƯỚC:
  1. Producer chỉ gửi rồi đi tiếp (KHÔNG chờ consumer).
  2. Consumer sập tạm -> broker GIỮ message, xử lý sau khi sống lại.
  3. ack sau khi xử lý xong; lỗi -> nack/requeue để thử lại.

ĐÁNH ĐỔI: nhất quán cuối cùng, khó lần luồng, cần idempotent (message có
thể giao trùng). Nền của event-driven architecture.'
,description_en=
'Services communicate through a MESSAGE BROKER, not directly waiting on
each other -> less coupling, better fault tolerance.

  Producer ─► [ Broker: Kafka / RabbitMQ / SQS ] ─► Consumer(s)

EXAMPLE (RabbitMQ, amqplib):
  // Producer
  const ch = await conn.createChannel();
  await ch.assertQueue("order.created");
  ch.sendToQueue("order.created", Buffer.from(JSON.stringify(order)));

  // Consumer
  await ch.consume("order.created", (msg) => {
    const order = JSON.parse(msg.content.toString());
    sendEmail(order);
    ch.ack(msg);            // acknowledge it is fully processed
  });

TWO STYLES:
  • Message queue (point-to-point): each message goes to EXACTLY one
    consumer (background work: send email, resize image).
  • Pub/Sub event: one event, MANY services listen (OrderPlaced ->
    Inventory, Email, Analytics all react).

STEP BY STEP:
  1. The producer just sends and moves on (does NOT wait for consumers).
  2. A temporarily-down consumer -> the broker KEEPS the message, processed
     after it recovers.
  3. ack after processing; on error -> nack/requeue to retry.

TRADE-OFF: eventual consistency, harder to trace, needs idempotency
(messages may be delivered twice). The basis of event-driven architecture.'
WHERE id='n_ms_async';

UPDATE kg_nodes SET
description=
'Trong hệ phân tán, lỗi mạng là BÌNH THƯỜNG -> phải chống lỗi lan
truyền (cascading failure) làm sập cả hệ.

CÁC KỸ THUẬT:
  • Timeout         : luôn đặt, đừng chờ vô hạn service chậm.
  • Retry + backoff : thử lại với độ trễ TĂNG DẦN + jitter (tránh
    retry storm làm ngập service đang yếu).
  • Circuit breaker : đích lỗi liên tục -> "mở mạch", trả lỗi/fallback
    nhanh một thời gian -> cho đích hồi phục.
  • Bulkhead        : cô lập tài nguyên (pool riêng) để một phần lỗi
    không kéo sập toàn bộ.

TRẠNG THÁI CIRCUIT BREAKER:
  closed (gọi bình thường)
    -- lỗi vượt ngưỡng -->
  open (chặn, trả lỗi/fallback ngay)
    -- sau thời gian chờ -->
  half-open (thử vài lời gọi) -- ok --> closed  | -- lỗi --> open

VÍ DỤ (opossum, Node.js):
  const CircuitBreaker = require("opossum");
  const breaker = new CircuitBreaker(callPaymentApi, {
    timeout: 3000,                // 3s không phản hồi -> coi là lỗi
    errorThresholdPercentage: 50, // > 50% lỗi -> mở mạch
    resetTimeout: 10000,          // 10s sau -> half-open thử lại
  });
  breaker.fallback(() => ({ queued: true }));   // fallback khi mở mạch
  await breaker.fire(order);

GIẢI THÍCH: mở mạch giúp KHÔNG dồn thêm request vào service đang chết,
trả lỗi nhanh để phần còn lại của hệ thống vẫn phản hồi được.'
,description_en=
'In a distributed system, network failures are NORMAL -> you must prevent
cascading failures from bringing down the whole system.

TECHNIQUES:
  • Timeout         : always set one; never wait forever on a slow service.
  • Retry + backoff : retry with INCREASING delay + jitter (avoid a
    retry storm flooding an already weak service).
  • Circuit breaker : a target keeps failing -> "open the circuit", return
    a fast error/fallback for a while -> let the target recover.
  • Bulkhead        : isolate resources (separate pools) so one failing
    part does not sink everything.

CIRCUIT BREAKER STATES:
  closed (normal calls)
    -- errors exceed threshold -->
  open (blocked, fast error/fallback)
    -- after a wait -->
  half-open (try a few calls) -- ok --> closed  | -- fail --> open

EXAMPLE (opossum, Node.js):
  const CircuitBreaker = require("opossum");
  const breaker = new CircuitBreaker(callPaymentApi, {
    timeout: 3000,                // no response in 3s -> treated as failure
    errorThresholdPercentage: 50, // > 50% failures -> open the circuit
    resetTimeout: 10000,          // after 10s -> half-open, retry
  });
  breaker.fallback(() => ({ queued: true }));   // fallback when open
  await breaker.fire(order);

EXPLANATION: opening the circuit avoids piling more requests onto a dying
service, failing fast so the rest of the system stays responsive.'
WHERE id='n_ms_circuit';

-- ĐÀO SÂU Microservices (đợt 3f): Intro, Boundaries, DB-per-service, Sync
UPDATE kg_nodes SET
description=
'Microservices = chia hệ thống lớn thành NHIỀU service nhỏ; mỗi service
tự chủ (own DB, own deploy), gói một nghiệp vụ, giao tiếp qua mạng
(HTTP/gRPC/message).

MONOLITH vs MICROSERVICES:
  Monolith                     Microservices
  ─────────────────────        ─────────────────────
  1 codebase, 1 deploy         nhiều service, deploy riêng
  1 DB dùng chung              mỗi service một DB riêng
  scale cả khối                scale từng service độc lập
  gọi hàm trong process        gọi qua mạng (chậm hơn, có thể lỗi)
  đơn giản khi nhỏ             phức tạp vận hành (network, monitor)

KHI NÀO NÊN DÙNG:
  ✓ team lớn, muốn deploy độc lập, các phần scale khác nhau rõ rệt.
  ✗ team nhỏ / sản phẩm mới -> BẮT ĐẦU BẰNG MONOLITH (đơn giản), tách
    service khi thật sự cần ("monolith first").

ĐÁNH ĐỔI CỐT LÕI: đổi độ phức tạp trong CODE lấy độ phức tạp VẬN HÀNH +
hệ phân tán (latency, lỗi một phần, nhất quán cuối cùng). Đừng chọn
microservices chỉ vì "nghe hiện đại".'
,description_en=
'Microservices = splitting a large system into MANY small services; each
is autonomous (own DB, own deploy), wraps one business capability, and
communicates over the network (HTTP/gRPC/message).

MONOLITH vs MICROSERVICES:
  Monolith                     Microservices
  ─────────────────────        ─────────────────────
  1 codebase, 1 deploy         many services, deployed separately
  1 shared DB                  one DB per service
  scale the whole block        scale each service independently
  in-process function calls    network calls (slower, can fail)
  simple while small           operationally complex (network, monitor)

WHEN TO USE:
  ✓ large team, wanting independent deploys, parts scaling very differently.
  ✗ small team / new product -> START WITH A MONOLITH (simpler), split
    into services only when truly needed ("monolith first").

CORE TRADE-OFF: you trade CODE complexity for OPERATIONAL complexity + a
distributed system (latency, partial failure, eventual consistency). Do
not pick microservices just because it "sounds modern".'
WHERE id='n_ms_intro';

UPDATE kg_nodes SET
description=
'Chia service THEO NGHIỆP VỤ (business capability / bounded context),
KHÔNG theo tầng kỹ thuật.

  ✗ SAI (theo tầng): ControllerSvc, RepositorySvc, DatabaseSvc
     -> mọi thay đổi nghiệp vụ phải sửa nhiều service (coupling cao).
  ✓ ĐÚNG (theo miền): OrderSvc, PaymentSvc, InventorySvc
     -> mỗi service sở hữu trọn một nghiệp vụ + dữ liệu của nó.

NGUYÊN TẮC (từ Domain-Driven Design):
  • Bounded context : mỗi service là một ranh giới mô hình rõ ràng;
    "Customer" trong Billing khác "Customer" trong Support.
  • High cohesion   : thứ hay thay đổi CÙNG NHAU nằm trong CÙNG service.
  • Loose coupling  : service ít phụ thuộc nhau; đổi bên trong không lan.

DẤU HIỆU CHIA SAI:
  - Một thay đổi nghiệp vụ phải sửa NHIỀU service cùng lúc.
  - Hai service liên tục gọi nhau đồng bộ theo vòng -> nên gộp lại.

Chia đúng ranh giới là quyết định KHÓ và quan trọng nhất của
microservices; chia sai -> "distributed monolith" (tệ hơn cả monolith).'
,description_en=
'Split services by BUSINESS CAPABILITY (bounded context), NOT by technical
layer.

  ✗ WRONG (by layer): ControllerSvc, RepositorySvc, DatabaseSvc
     -> every business change edits multiple services (high coupling).
  ✓ RIGHT (by domain): OrderSvc, PaymentSvc, InventorySvc
     -> each service fully owns one capability + its data.

PRINCIPLES (from Domain-Driven Design):
  • Bounded context : each service is a clear model boundary; a
    "Customer" in Billing differs from a "Customer" in Support.
  • High cohesion   : things that change TOGETHER live in the SAME service.
  • Loose coupling  : services barely depend on each other; internal
    changes do not ripple out.

SIGNS OF BAD BOUNDARIES:
  - One business change forces edits across MANY services at once.
  - Two services constantly call each other synchronously in a loop
    -> they should be merged.

Getting boundaries right is the HARDEST and most important decision in
microservices; getting it wrong -> a "distributed monolith" (worse than
a monolith).'
WHERE id='n_ms_boundaries';

UPDATE kg_nodes SET
description=
'Mỗi service SỞ HỮU DB riêng; service khác KHÔNG được chạm trực tiếp DB
đó -> phải đi qua API/event.

  OrderSvc ─► orders_db          PaymentSvc ─► payments_db
    (chỉ OrderSvc chạm orders_db)   (chỉ PaymentSvc chạm payments_db)

VÌ SAO:
  1. Tách rời (decoupling): đổi schema nội bộ không phá service khác.
  2. Chọn đúng công nghệ: service này Postgres, service kia Mongo/Redis.
  3. Scale và fail độc lập.

HỆ QUẢ (điểm khó):
  • KHÔNG JOIN xuyên service -> cần dữ liệu của service khác thì gọi API
    hoặc giữ bản sao cục bộ cập nhật qua event (data replication).
  • KHÔNG transaction ACID xuyên service -> dùng Saga + Outbox để đạt
    nhất quán CUỐI CÙNG.

  ✗ SAI: nhiều service cùng ghi vào MỘT bảng dùng chung
     -> coupling ngầm, không tách deploy được (distributed monolith).

Đây chính là điều PHÂN BIỆT microservices thật với một monolith bị chẻ nhỏ.'
,description_en=
'Each service OWNS its own DB; other services must NOT touch that DB
directly -> they must go through APIs/events.

  OrderSvc ─► orders_db          PaymentSvc ─► payments_db
    (only OrderSvc touches orders_db)   (only PaymentSvc touches payments_db)

WHY:
  1. Decoupling: internal schema changes do not break other services.
  2. Right tool per service: one uses Postgres, another Mongo/Redis.
  3. Independent scaling and failure.

CONSEQUENCES (the hard part):
  • NO cross-service JOINs -> to use another service data, call its API or
    keep a local copy updated via events (data replication).
  • NO ACID transactions across services -> use Saga + Outbox to reach
    EVENTUAL consistency.

  ✗ WRONG: multiple services writing to ONE shared table
     -> hidden coupling, deploys cannot be separated (distributed monolith).

This is exactly what DISTINGUISHES real microservices from a chopped-up
monolith.'
WHERE id='n_ms_db_per_service';

UPDATE kg_nodes SET
description=
'Giao tiếp ĐỒNG BỘ: caller gọi và CHỜ phản hồi ngay (request/response).

HAI LỰA CHỌN PHỔ BIẾN:
  • REST/HTTP + JSON        : phổ biến, dễ debug, hợp API công khai.
  • gRPC (HTTP/2 + protobuf): nhị phân, nhanh, có schema + streaming,
    hợp giao tiếp NỘI BỘ service-to-service.

VÍ DỤ gọi service khác (REST, có timeout):
  const res = await fetch("http://inventory/api/stock/42", {
    signal: AbortSignal.timeout(3000),   // LUÔN đặt timeout
  });
  if (!res.ok) throw new Error("inventory " + res.status);
  const stock = await res.json();

RỦI RO PHẢI XỬ LÝ:
  1. Latency cộng dồn: A -> B -> C, mỗi hop thêm độ trễ.
  2. Ghép chặt tạm thời (temporal coupling): B chết -> A cũng lỗi theo.
  3. Cascading failure -> cần timeout + retry + circuit breaker.

KHI NÀO DÙNG SYNC: cần kết quả NGAY để trả cho user (đọc dữ liệu, xác
thực). Việc nền/thông báo -> ưu tiên ASYNC (message) để giảm coupling.'
,description_en=
'SYNCHRONOUS communication: the caller calls and WAITS for an immediate
response (request/response).

TWO COMMON CHOICES:
  • REST/HTTP + JSON        : popular, easy to debug, good for public APIs.
  • gRPC (HTTP/2 + protobuf): binary, fast, has a schema + streaming,
    good for INTERNAL service-to-service calls.

EXAMPLE calling another service (REST, with a timeout):
  const res = await fetch("http://inventory/api/stock/42", {
    signal: AbortSignal.timeout(3000),   // ALWAYS set a timeout
  });
  if (!res.ok) throw new Error("inventory " + res.status);
  const stock = await res.json();

RISKS TO HANDLE:
  1. Additive latency: A -> B -> C, each hop adds delay.
  2. Temporal coupling: if B is down -> A fails too.
  3. Cascading failure -> needs timeout + retry + circuit breaker.

WHEN TO USE SYNC: you need the result IMMEDIATELY to return to the user
(reading data, authentication). Background work/notifications -> prefer
ASYNC (messaging) to reduce coupling.'
WHERE id='n_ms_sync';

-- ĐÀO SÂU Microservices (đợt 3g): Gateway, CQRS, Discovery, Observability
UPDATE kg_nodes SET
description=
'API Gateway = CỬA NGÕ duy nhất giữa client và cụm service bên trong.
Client chỉ gọi gateway; gateway định tuyến tới service phù hợp.

  Client ─► [ API Gateway ] ─┬─► OrderService
                             ├─► PaymentService
                             └─► UserService

GATEWAY LO CÁC VIỆC CẮT NGANG (cross-cutting):
  • Routing       : /orders/* -> OrderSvc, /users/* -> UserSvc
  • Auth          : xác thực JWT MỘT LẦN ở cửa, service bên trong tin tưởng
  • Rate limiting : chặn lạm dụng
  • Aggregation   : gộp nhiều lời gọi service thành 1 response cho client
  • TLS, CORS, log, cache tập trung

VÍ DỤ (Express làm gateway đơn giản):
  app.use("/orders", auth, proxy("http://order-svc"));
  app.use("/users",  auth, proxy("http://user-svc"));

LỢI ÍCH: client KHÔNG cần biết địa chỉ/số lượng service; đổi cấu trúc
bên trong không ảnh hưởng client. BFF (Backend-for-Frontend) là gateway
riêng cho từng loại client (web / mobile).

CẢNH BÁO: gateway dễ thành nút nghẽn / single point of failure -> chạy
nhiều bản và giữ nó MỎNG (chỉ điều phối, KHÔNG nhồi business logic).'
,description_en=
'An API Gateway = the single ENTRANCE between clients and the internal
service cluster. Clients only call the gateway; it routes to the right
service.

  Client ─► [ API Gateway ] ─┬─► OrderService
                             ├─► PaymentService
                             └─► UserService

THE GATEWAY HANDLES CROSS-CUTTING CONCERNS:
  • Routing       : /orders/* -> OrderSvc, /users/* -> UserSvc
  • Auth          : verify the JWT ONCE at the door; inner services trust it
  • Rate limiting : block abuse
  • Aggregation   : combine several service calls into one client response
  • TLS, CORS, logging, centralized cache

EXAMPLE (Express as a simple gateway):
  app.use("/orders", auth, proxy("http://order-svc"));
  app.use("/users",  auth, proxy("http://user-svc"));

BENEFITS: clients need NOT know the address/number of services; internal
restructuring does not affect them. A BFF (Backend-for-Frontend) is a
dedicated gateway per client type (web / mobile).

WARNING: the gateway easily becomes a bottleneck / single point of
failure -> run multiple instances and keep it THIN (routing only, NO
business logic).'
WHERE id='n_ms_gateway';

UPDATE kg_nodes SET
description=
'CQRS (Command Query Responsibility Segregation): tách MÔ HÌNH GHI
(command) khỏi MÔ HÌNH ĐỌC (query) — hai đường đi, thậm chí hai store.

  Ghi: Command ─► Domain model ─► write DB (chuẩn hóa, đảm bảo ràng buộc)
                      │ (event)
                      ▼
  Đọc: Query   ◄─ read model  ◄─ projection (phi chuẩn hóa, tối ưu đọc)

VÍ DỤ: web bán hàng ĐỌC gấp nhiều lần GHI.
  • Write side: đặt hàng -> validate + ghi bảng orders chuẩn hóa.
  • Read side : projection dựng sẵn bảng phẳng "order_summary" cho trang
    lịch sử đơn -> đọc 1 truy vấn, không JOIN nặng.

GIẢI THÍCH TỪNG BƯỚC:
  1. Command đổi trạng thái, KHÔNG trả dữ liệu đọc.
  2. Query chỉ đọc, KHÔNG đổi trạng thái.
  3. Read model được cập nhật qua event từ write side -> nhất quán
     CUỐI CÙNG (có độ trễ nhỏ).

DÙNG KHI: đọc/ghi mất cân đối lớn, hoặc read cần hình dạng khác hẳn
write. Thường đi cùng Event Sourcing.

ĐÁNH ĐỔI: thêm phức tạp + độ trễ đồng bộ read model -> ĐỪNG dùng cho
CRUD đơn giản.'
,description_en=
'CQRS (Command Query Responsibility Segregation): separate the WRITE
model (commands) from the READ model (queries) - two paths, even two stores.

  Write: Command ─► Domain model ─► write DB (normalized, enforces rules)
                        │ (event)
                        ▼
  Read:  Query   ◄─ read model  ◄─ projection (denormalized, read-optimized)

EXAMPLE: an e-commerce site READS far more than it WRITES.
  • Write side: place order -> validate + write a normalized orders table.
  • Read side : a projection prebuilds a flat "order_summary" table for
    the order-history page -> one query read, no heavy JOINs.

STEP BY STEP:
  1. A command changes state and does NOT return read data.
  2. A query only reads and does NOT change state.
  3. The read model is updated via events from the write side -> EVENTUAL
     consistency (small lag).

USE WHEN: read/write are highly imbalanced, or reads need a very
different shape than writes. Often paired with Event Sourcing.

TRADE-OFF: extra complexity + read-model sync lag -> do NOT use it for
simple CRUD.'
WHERE id='n_ms_cqrs';

UPDATE kg_nodes SET
description=
'Trong microservices, service scale lên/xuống liên tục -> IP/địa chỉ
THAY ĐỔI. Service discovery giúp tìm địa chỉ động thay vì hardcode.

  Service B khởi động ─► ĐĂNG KÝ vào registry (Consul / Eureka / etcd)
  Service A cần B      ─► HỎI registry -> nhận danh sách địa chỉ B đang sống

HAI KIỂU:
  • Client-side : A hỏi registry rồi tự chọn instance (tự load balance).
  • Server-side : A gọi một địa chỉ ổn định (load balancer / DNS ảo);
    hạ tầng lo định tuyến tới instance sống.

TRONG KUBERNETES (phổ biến nhất hiện nay):
  • Mỗi Service có DNS name ổn định: http://order-svc.default.svc
  • kube-proxy + Service tự cân bằng tải sang các Pod đang sống.
  • readiness probe loại Pod chưa/không sẵn sàng khỏi danh sách.
  -> app chỉ cần gọi TÊN service, K8s lo discovery + load balance.

CỐT LÕI: đừng hardcode IP; dùng tên logic + registry/DNS để hệ thống tự
thích ứng khi instance thay đổi.'
,description_en=
'In microservices, services scale up/down constantly -> IPs/addresses
CHANGE. Service discovery finds addresses dynamically instead of
hardcoding them.

  Service B starts ─► REGISTERS into a registry (Consul / Eureka / etcd)
  Service A needs B ─► ASKS the registry -> gets the list of live B addresses

TWO STYLES:
  • Client-side : A asks the registry then picks an instance (self load-balance).
  • Server-side : A calls one stable address (a load balancer / virtual DNS);
    the infrastructure routes to a live instance.

IN KUBERNETES (the most common today):
  • Each Service has a stable DNS name: http://order-svc.default.svc
  • kube-proxy + the Service load-balance across the live Pods.
  • a readiness probe removes not-ready Pods from the list.
  -> the app just calls the service NAME, K8s handles discovery + balancing.

KEY IDEA: never hardcode IPs; use logical names + a registry/DNS so the
system adapts as instances change.'
WHERE id='n_ms_discovery';

UPDATE kg_nodes SET
description=
'Hệ phân tán khó debug: một request đi qua NHIỀU service. Observability =
khả năng hiểu hệ thống đang làm gì từ dữ liệu nó phát ra. Ba trụ cột:

  1. LOGS    — sự kiện rời rạc. Nên structured (JSON) + có
     correlation/trace id để NỐI log của cùng một request qua các service.
  2. METRICS — số đo theo thời gian (RPS, latency p95, error rate, CPU).
     Prometheus thu thập, Grafana vẽ, cảnh báo khi vượt ngưỡng.
  3. TRACES  — dấu vết MỘT request xuyên nhiều service (distributed
     tracing): mỗi service tạo một span, nối theo trace id.

  Request ──[trace-id=abc]──► Gateway ─► OrderSvc ─► PaymentSvc
                                 span       span         span
     -> xem timeline: hop nào chậm, hop nào lỗi.

CÔNG CỤ: OpenTelemetry (chuẩn thu thập), Jaeger/Tempo (trace),
Prometheus + Grafana (metrics), ELK/Loki (logs).

THỰC HÀNH THEN CHỐT: truyền trace id qua MỌI hop (qua header) -> mới ghép
được bức tranh toàn cảnh. Không có observability, microservices gần như
không thể vận hành.'
,description_en=
'Distributed systems are hard to debug: one request passes through MANY
services. Observability = the ability to understand what the system is
doing from the data it emits. Three pillars:

  1. LOGS    — discrete events. Should be structured (JSON) + carry a
     correlation/trace id to LINK logs of the same request across services.
  2. METRICS — time-series measurements (RPS, p95 latency, error rate, CPU).
     Prometheus collects, Grafana visualizes, alerts fire on thresholds.
  3. TRACES  — the trail of ONE request across many services (distributed
     tracing): each service creates a span, joined by the trace id.

  Request ──[trace-id=abc]──► Gateway ─► OrderSvc ─► PaymentSvc
                                 span       span         span
     -> see the timeline: which hop is slow, which hop errored.

TOOLS: OpenTelemetry (collection standard), Jaeger/Tempo (traces),
Prometheus + Grafana (metrics), ELK/Loki (logs).

KEY PRACTICE: propagate the trace id through EVERY hop (via headers) -> only
then can you assemble the full picture. Without observability,
microservices are nearly impossible to operate.'
WHERE id='n_ms_observability';

-- ĐÀO SÂU React (đợt 4a): useState, useEffect, useMemo/useCallback, Rules of Hooks
UPDATE kg_nodes SET
description=
'useState thêm state cục bộ cho function component. Đổi state -> React
lên lịch re-render component đó.

  const [count, setCount] = useState(0);   // [giá trị, hàm cập nhật]

QUY TẮC QUAN TRỌNG:
1) State là BẤT BIẾN — tạo mới, đừng sửa tại chỗ:
  ✗ user.name = "An"; setUser(user);   // cùng reference -> React coi như
                                       //   KHÔNG đổi -> bỏ render
  ✓ setUser({ ...user, name: "An" });  // object MỚI -> re-render

2) Cập nhật theo BATCH + BẤT ĐỒNG BỘ. Nhiều setState trong 1 event gộp
   lại, render một lần. Đọc count ngay sau set vẫn là giá trị cũ:
  ✗ setCount(count + 1); setCount(count + 1);   // cùng count -> chỉ +1
  ✓ setCount(c => c + 1); setCount(c => c + 1); // updater -> +2 đúng

3) LAZY INIT cho khởi tạo tốn kém (chỉ chạy lần đầu):
  const [v] = useState(() => expensiveInit());  // truyền HÀM, không giá trị

GIẢI THÍCH TỪNG BƯỚC:
  1. setState báo React có state mới -> đưa component vào hàng render.
  2. React so sánh reference -> KHÁC mới render (nên cần object/array mới).
  3. Dùng dạng updater c => ... khi giá trị mới phụ thuộc giá trị cũ.'
,description_en=
'useState adds local state to a function component. Changing state ->
React schedules a re-render of that component.

  const [count, setCount] = useState(0);   // [value, updater function]

KEY RULES:
1) State is IMMUTABLE - create a new value, do not mutate in place:
  ✗ user.name = "An"; setUser(user);   // same reference -> React sees NO
                                       //   change -> skips the render
  ✓ setUser({ ...user, name: "An" });  // a NEW object -> re-renders

2) Updates are BATCHED + ASYNCHRONOUS. Multiple setState calls in one
   event are merged into one render. Reading count right after setting it
   still gives the old value:
  ✗ setCount(count + 1); setCount(count + 1);   // same count -> only +1
  ✓ setCount(c => c + 1); setCount(c => c + 1); // updater -> +2 correctly

3) LAZY INIT for expensive initialization (runs only on first render):
  const [v] = useState(() => expensiveInit());  // pass a FUNCTION, not a value

STEP BY STEP:
  1. setState tells React there is new state -> queues the component to render.
  2. React compares by reference -> renders only if DIFFERENT (hence a new
     object/array is needed).
  3. Use the updater form c => ... when the new value depends on the old one.'
WHERE id='n_rc_usestate';

UPDATE kg_nodes SET
description=
'useEffect chạy SIDE EFFECT (fetch, subscription, timer, thao tác DOM)
SAU khi render, để đồng bộ component với hệ thống bên ngoài.

  useEffect(() => {
    const id = setInterval(tick, 1000);
    return () => clearInterval(id);  // CLEANUP: chạy trước lần sau + khi unmount
  }, []);                            // dependency array

DEPENDENCY ARRAY quyết định KHI NÀO chạy lại:
  useEffect(fn)             // MỖI lần render
  useEffect(fn, [])         // CHỈ 1 lần (mount)
  useEffect(fn, [userId])   // chạy lại khi userId đổi

LỖI THƯỜNG GẶP:
  ✗ thiếu dependency -> effect dùng giá trị CŨ (stale closure).
  ✗ fetch không kiểm soát race -> response cũ ghi đè response mới.
  ✓ có cleanup + cờ hủy:
     useEffect(() => {
       let alive = true;
       fetch(`/user/${id}`).then(r => r.json())
         .then(d => { if (alive) setUser(d); });
       return () => { alive = false; };   // hủy khi id đổi/unmount
     }, [id]);

GIẢI THÍCH: effect KHÔNG dành cho việc biến đổi dữ liệu lúc render (cái
đó tính trực tiếp trong thân component). Chỉ dùng khi cần đồng bộ với
BÊN NGOÀI React. Nhiều thứ trước hay nhét vào effect nay nên bỏ (React
docs: "You Might Not Need an Effect").'
,description_en=
'useEffect runs a SIDE EFFECT (fetch, subscription, timer, DOM work) AFTER
render, to synchronize the component with an external system.

  useEffect(() => {
    const id = setInterval(tick, 1000);
    return () => clearInterval(id);  // CLEANUP: runs before next run + on unmount
  }, []);                            // dependency array

THE DEPENDENCY ARRAY decides WHEN it re-runs:
  useEffect(fn)             // on EVERY render
  useEffect(fn, [])         // ONCE (on mount)
  useEffect(fn, [userId])   // re-runs when userId changes

COMMON MISTAKES:
  ✗ missing a dependency -> the effect uses an OLD value (stale closure).
  ✗ an uncontrolled fetch race -> an old response overwrites a newer one.
  ✓ with cleanup + a cancel flag:
     useEffect(() => {
       let alive = true;
       fetch(`/user/${id}`).then(r => r.json())
         .then(d => { if (alive) setUser(d); });
       return () => { alive = false; };   // cancel when id changes/unmount
     }, [id]);

EXPLANATION: effects are NOT for transforming data during render (do that
directly in the component body). Use them only to sync with things
OUTSIDE React. Much of what people used to put in effects should now be
removed (React docs: "You Might Not Need an Effect").'
WHERE id='n_rc_useeffect';

UPDATE kg_nodes SET
description=
'useMemo và useCallback GHI NHỚ (memoize) để tránh tính lại / tạo lại
mỗi render — đây là TỐI ƯU, không phải mặc định.

useMemo — nhớ KẾT QUẢ một tính toán tốn kém:
  const sorted = useMemo(
    () => bigList.slice().sort(cmp),   // chỉ chạy lại khi bigList đổi
    [bigList]
  );

useCallback — nhớ chính HÀM (giữ nguyên reference giữa các render):
  const onClick = useCallback(() => doSomething(id), [id]);
  // useCallback(fn, dep) tương đương useMemo(() => fn, dep)

VÌ SAO CẦN: khi truyền hàm/object xuống con đã React.memo. Mỗi render
cha tạo hàm MỚI -> reference khác -> con vẫn render lại dù props giống.
useCallback giữ reference ổn định -> memo của con mới phát huy.

  ✗ <Child onClick={() => f()} />   // hàm mới mỗi render -> memo vô dụng
  ✓ const cb = useCallback(() => f(), []);
    <Child onClick={cb} />          // reference ổn định

CẢNH BÁO: memo có chi phí (lưu + so deps). Đừng bọc mọi thứ; chỉ dùng
khi (a) tính toán thật sự nặng, hoặc (b) cần reference ổn định cho con
đã memo. Lạm dụng làm code rối mà không nhanh hơn.'
,description_en=
'useMemo and useCallback MEMOIZE to avoid recomputing / recreating on every
render - this is an OPTIMIZATION, not the default.

useMemo - remembers the RESULT of an expensive computation:
  const sorted = useMemo(
    () => bigList.slice().sort(cmp),   // recomputes only when bigList changes
    [bigList]
  );

useCallback - remembers the FUNCTION itself (stable reference across renders):
  const onClick = useCallback(() => doSomething(id), [id]);
  // useCallback(fn, dep) is equivalent to useMemo(() => fn, dep)

WHY IT IS NEEDED: when passing a function/object to a React.memo child.
Each parent render creates a NEW function -> different reference -> the
child re-renders even with identical props. useCallback keeps the
reference stable -> the child memo actually works.

  ✗ <Child onClick={() => f()} />   // new function each render -> memo useless
  ✓ const cb = useCallback(() => f(), []);
    <Child onClick={cb} />          // stable reference

WARNING: memoization has a cost (storing + comparing deps). Do not wrap
everything; use it only when (a) the computation is genuinely heavy, or
(b) you need a stable reference for a memoized child. Overusing it clutters
the code without making it faster.'
WHERE id='n_rc_usememo_cb';

UPDATE kg_nodes SET
description=
'RULES OF HOOKS — 2 luật bắt buộc để React khớp đúng state với mỗi hook:

1) CHỈ gọi hook ở TOP LEVEL — không trong if/for/hàm lồng.
   React nhận diện hook theo THỨ TỰ GỌI; gọi có điều kiện -> lệch thứ tự.
  ✗ if (open) { const [x] = useState(0); }        // sai
  ✓ const [x] = useState(0); if (open) { ... }    // đúng

2) CHỈ gọi hook trong React function component hoặc custom hook (KHÔNG
   trong hàm thường, KHÔNG trong class).

CUSTOM HOOK — tách logic dùng state/effect ra hàm tái dùng (tên bắt đầu
bằng "use"):
  function useToggle(init = false) {
    const [on, setOn] = useState(init);
    const toggle = useCallback(() => setOn(o => !o), []);
    return [on, toggle];
  }
  // dùng: const [open, toggleOpen] = useToggle();

GIẢI THÍCH TỪNG BƯỚC:
  1. Mỗi lần render, các hook chạy theo ĐÚNG thứ tự -> React map state.
  2. Custom hook chỉ là hàm GỌI các hook khác -> gói logic, KHÔNG chia sẻ
     state giữa các component (mỗi component gọi có state RIÊNG).
  3. Đặt tên use* để linter kiểm được luật hook.

Lợi ích: tái dùng logic (fetch, form, subscription) mà không cần HOC /
render-props lồng sâu như trước.'
,description_en=
'RULES OF HOOKS - 2 mandatory rules so React matches state to each hook:

1) Only call hooks at the TOP LEVEL - not inside if/for/nested functions.
   React identifies hooks by CALL ORDER; conditional calls skew the order.
  ✗ if (open) { const [x] = useState(0); }        // wrong
  ✓ const [x] = useState(0); if (open) { ... }    // correct

2) Only call hooks inside a React function component or a custom hook
   (NOT in a plain function, NOT in a class).

CUSTOM HOOK - extract state/effect logic into a reusable function (name
starts with "use"):
  function useToggle(init = false) {
    const [on, setOn] = useState(init);
    const toggle = useCallback(() => setOn(o => !o), []);
    return [on, toggle];
  }
  // usage: const [open, toggleOpen] = useToggle();

STEP BY STEP:
  1. On each render, hooks run in the SAME order -> React maps their state.
  2. A custom hook is just a function that CALLS other hooks -> it packages
     logic, it does NOT share state between components (each caller gets its
     OWN state).
  3. Name it use* so the linter can enforce the hook rules.

Benefit: reuse logic (fetch, form, subscription) without deeply nested
HOCs / render-props like before.'
WHERE id='n_rc_rules';

-- ĐÀO SÂU React (đợt 4b): Re-render, Perf, Virtual DOM, Fiber, Keys
UPDATE kg_nodes SET
description=
'Một component re-render khi MỘT trong các điều sau xảy ra:
  1. State của chính nó đổi (setState).
  2. Props từ cha đổi.
  3. Cha nó re-render (mặc định con render THEO, dù props không đổi!).
  4. Context nó đang dùng đổi giá trị.

  Cha render ─► TẤT CẢ con render (mặc định) ─► cháu render ...
     (React KHÔNG tự so props; nó render lại cả cây con)

HIỂU LẦM PHỔ BIẾN: "props không đổi thì con không render" -> SAI. Con
render vì CHA render. Muốn chặn phải React.memo:
  const Child = React.memo(function Child({ value }) { ... });
  // giờ Child chỉ render khi prop value đổi (so sánh nông)

RE-RENDER != CẬP NHẬT DOM:
  render (chạy hàm component) -> tạo virtual DOM -> React DIFF -> chỉ
  phần DOM khác mới bị đụng. Render lại KHÔNG đồng nghĩa thao tác DOM
  thật, nhưng render thừa vẫn tốn CPU (diff + tính toán).

GIẢI THÍCH TỪNG BƯỚC:
  1. Trigger (state/props/context) -> React gọi lại hàm component.
  2. So sánh output (reconciliation) với lần trước.
  3. Chỉ commit khác biệt xuống DOM.

Biết điều này để tối ưu ĐÚNG chỗ: giảm render thừa (memo, đưa state
xuống thấp) thay vì tối ưu mù.'
,description_en=
'A component re-renders when ONE of these happens:
  1. Its own state changes (setState).
  2. Props from the parent change.
  3. Its parent re-renders (by default children follow, even if props are
     unchanged!).
  4. A Context it consumes changes value.

  Parent renders ─► ALL children render (default) ─► grandchildren render ...
     (React does NOT auto-compare props; it re-renders the whole subtree)

COMMON MISCONCEPTION: "if props are unchanged the child does not render"
-> WRONG. The child renders because the PARENT rendered. To stop it use
React.memo:
  const Child = React.memo(function Child({ value }) { ... });
  // now Child renders only when the value prop changes (shallow compare)

RE-RENDER != DOM UPDATE:
  render (running the component function) -> builds virtual DOM -> React
  DIFFs -> only the differing DOM is touched. A re-render does NOT mean real
  DOM work, but wasted renders still cost CPU (diffing + computation).

STEP BY STEP:
  1. A trigger (state/props/context) -> React re-calls the component function.
  2. It compares the output (reconciliation) with the previous one.
  3. It commits only the difference to the DOM.

Knowing this lets you optimize the RIGHT spot: cut wasted renders (memo,
push state lower) instead of optimizing blindly.'
WHERE id='n_rc_render';

UPDATE kg_nodes SET
description=
'Tối ưu re-render = ngăn render THỪA. Thứ tự ưu tiên (làm từ trên xuống):

1) SỬA CẤU TRÚC trước khi memo:
   • Đưa state xuống THẤP nhất có thể (state colocation) -> chỉ nhánh cần
     mới render.
   • "Lift content up": truyền children thay vì render bên trong:
     <Slow>{<Heavy/>}</Slow>  // Heavy không render lại khi Slow đổi state

2) React.memo — chặn con render khi props không đổi (so sánh nông):
   const Row = React.memo(RowBase);

3) useMemo/useCallback — giữ reference props ổn định cho con đã memo,
   hoặc nhớ tính toán nặng.

4) Danh sách dài -> VIRTUALIZATION (react-window): chỉ render item trong
   viewport thay vì cả nghìn dòng.

VÍ DỤ colocation (sửa cấu trúc, không cần memo):
  ✗ state ô input nằm ở cha -> gõ phím render cả trang
  ✓ tách <SearchBox/> giữ state của nó -> gõ chỉ render SearchBox

ĐO TRƯỚC KHI TỐI ƯU: React DevTools Profiler chỉ ra component nào render
nhiều/chậm. Đừng rải memo khắp nơi — đo, tìm điểm nóng, sửa đúng chỗ.'
,description_en=
'Optimizing re-renders = preventing WASTED renders. Priority order (top down):

1) FIX STRUCTURE before reaching for memo:
   • Push state as LOW as possible (state colocation) -> only the branch
     that needs it re-renders.
   • "Lift content up": pass children instead of rendering inside:
     <Slow>{<Heavy/>}</Slow>  // Heavy does not re-render when Slow changes state

2) React.memo - stop a child rendering when props are unchanged (shallow):
   const Row = React.memo(RowBase);

3) useMemo/useCallback - keep prop references stable for memoized children,
   or remember heavy computations.

4) Long lists -> VIRTUALIZATION (react-window): render only items in the
   viewport instead of thousands of rows.

COLOCATION EXAMPLE (structural fix, no memo needed):
  ✗ the input state lives in the parent -> typing re-renders the whole page
  ✓ extract <SearchBox/> holding its own state -> typing renders only SearchBox

MEASURE BEFORE OPTIMIZING: the React DevTools Profiler shows which
components render often/slowly. Do not sprinkle memo everywhere - measure,
find the hot spot, fix the right place.'
WHERE id='n_rc_perf';

UPDATE kg_nodes SET
description=
'Virtual DOM = cây object JS mô tả UI. React so cây MỚI với cây CŨ
(reconciliation) rồi chỉ cập nhật phần DOM thật sự khác -> ít chạm DOM
(vốn chậm).

  setState -> render() -> VDOM mới ─┐
                                    ├─ DIFF (so 2 cây) ─► patch DOM tối thiểu
                     VDOM cũ  ──────┘

THUẬT TOÁN DIFF (heuristic O(n)):
  1. Khác LOẠI element (div -> span) -> hủy cây con cũ, dựng mới.
  2. Cùng loại -> giữ node, chỉ cập nhật attribute/prop đổi.
  3. Danh sách con -> so theo KEY (nên diff hiệu quả cần key ổn định).

VÍ DỤ vì sao cần diff:
  UI cũ:  <ul><li>A</li><li>B</li></ul>
  UI mới: <ul><li>A</li><li>B</li><li>C</li></ul>
  -> React chỉ THÊM <li>C</li>, không dựng lại cả <ul>.

GIẢI THÍCH: VDOM không "nhanh hơn DOM" một cách kỳ diệu; nó giúp GOM và
GIẢM số thao tác DOM, đồng thời cho phép viết UI KHAI BÁO (mô tả trạng
thái, React lo cập nhật). Đây là nền cho keys, reconciliation và Fiber.'
,description_en=
'The Virtual DOM = a tree of JS objects describing the UI. React compares
the NEW tree with the OLD tree (reconciliation) then updates only the DOM
that truly differs -> fewer DOM touches (which are slow).

  setState -> render() -> new VDOM ─┐
                                    ├─ DIFF (compare 2 trees) ─► minimal DOM patch
                     old VDOM ──────┘

THE DIFF ALGORITHM (an O(n) heuristic):
  1. Different element TYPE (div -> span) -> discard the old subtree, build new.
  2. Same type -> keep the node, update only changed attributes/props.
  3. Child lists -> compared by KEY (efficient diffing needs stable keys).

WHY DIFFING MATTERS:
  old UI: <ul><li>A</li><li>B</li></ul>
  new UI: <ul><li>A</li><li>B</li><li>C</li></ul>
  -> React only ADDS <li>C</li>, it does not rebuild the whole <ul>.

EXPLANATION: the VDOM is not magically "faster than the DOM"; it BATCHES
and REDUCES DOM operations, and lets you write DECLARATIVE UI (describe the
state, React handles updates). It is the basis for keys, reconciliation,
and Fiber.'
WHERE id='n_rc_vdom';

UPDATE kg_nodes SET
description=
'Fiber = kiến trúc reconciler viết lại (React 16+) cho phép render CÓ THỂ
NGẮT (interruptible): chia công việc thành đơn vị (fiber) và làm theo
lát thời gian.

TRƯỚC (stack reconciler): diff chạy MỘT MẠCH, đồng bộ, không dừng được
-> cây lớn làm nghẽn main thread, UI khựng.

FIBER: chia việc thành các unit, có thể TẠM DỪNG / TIẾP TỤC / BỎ -> nhường
chỗ cho việc ưu tiên cao (gõ phím, animation).

CONCURRENT FEATURES (React 18, dựa trên Fiber):
  • useTransition — đánh dấu cập nhật KHÔNG khẩn -> giữ UI mượt:
      const [isPending, startTransition] = useTransition();
      startTransition(() => setQuery(text));  // lọc danh sách nặng
      // gõ phím (khẩn) vẫn mượt; kết quả lọc cập nhật ngay sau
  • useDeferredValue — hoãn một giá trị nặng chạy theo sau giá trị khẩn.
  • Suspense — chờ dữ liệu / lazy component, hiện fallback trong lúc chờ.

GIẢI THÍCH: Fiber cho React tách render thành 2 pha — RENDER (tính toán,
có thể ngắt) và COMMIT (đụng DOM, đồng bộ, nhanh, không ngắt). Nhờ đó có
ưu tiên hóa cập nhật và các tính năng concurrent.'
,description_en=
'Fiber = the rewritten reconciler architecture (React 16+) that makes
rendering INTERRUPTIBLE: it splits work into units (fibers) and processes
them in time slices.

BEFORE (the stack reconciler): diffing ran in ONE synchronous pass that
could not stop -> a large tree blocked the main thread and froze the UI.

FIBER: splits work into units that can PAUSE / RESUME / ABORT -> yielding to
higher-priority work (typing, animation).

CONCURRENT FEATURES (React 18, built on Fiber):
  • useTransition - marks a NON-urgent update -> keeps the UI smooth:
      const [isPending, startTransition] = useTransition();
      startTransition(() => setQuery(text));  // heavy list filtering
      // typing (urgent) stays smooth; filtered results update just after
  • useDeferredValue - defers a heavy value that trails an urgent value.
  • Suspense - waits for data / a lazy component, showing a fallback meanwhile.

EXPLANATION: Fiber lets React split rendering into 2 phases - RENDER
(computation, interruptible) and COMMIT (DOM mutation, synchronous, fast,
uninterruptible). This enables update prioritization and concurrent features.'
WHERE id='n_rc_fiber';

UPDATE kg_nodes SET
description=
'key giúp React nhận diện item nào là item nào khi danh sách thay đổi,
để tái dùng đúng DOM/state thay vì dựng lại.

  {items.map(it => <Row key={it.id} data={it} />)}  // key ỔN ĐỊNH, duy nhất

VÌ SAO KHÔNG DÙNG INDEX làm key khi danh sách đổi thứ tự/chèn/xóa:
  Danh sách: [A, B, C]   key = index 0,1,2
  Xóa A ->   [B, C]      B nhận key 0 (trước là của A)
  -> React tưởng "item 0 đổi nội dung A->B" và tái dùng SAI DOM/state.

HẬU QUẢ THỰC TẾ: ô input đang gõ ở dòng này nhảy sang dòng khác;
checkbox tick sai dòng; animation giật — vì state nội bộ bám theo key.

  ✗ items.map((it, i) => <Row key={i} .../>)   // sai khi reorder/insert
  ✓ items.map(it => <Row key={it.id} .../>)    // id ổn định theo dữ liệu

KHI NÀO index CHẤP NHẬN ĐƯỢC: danh sách TĨNH, không sắp xếp lại, không
thêm/xóa ở giữa.

GIẢI THÍCH: key là ĐỊNH DANH trong reconciliation của danh sách con. Đúng
key -> React ghép đúng phần tử cũ-mới -> giữ được state + patch tối thiểu.'
,description_en=
'A key lets React identify which item is which when a list changes, so it
reuses the right DOM/state instead of rebuilding.

  {items.map(it => <Row key={it.id} data={it} />)}  // STABLE, unique key

WHY NOT USE THE INDEX as the key when the list reorders/inserts/deletes:
  list: [A, B, C]   key = index 0,1,2
  delete A -> [B, C]   B now gets key 0 (previously A had it)
  -> React thinks "item 0 changed content A->B" and reuses the WRONG DOM/state.

REAL CONSEQUENCES: an input being typed in one row jumps to another row;
a checkbox ticks the wrong row; animations glitch - because internal state
sticks to the key.

  ✗ items.map((it, i) => <Row key={i} .../>)   // wrong on reorder/insert
  ✓ items.map(it => <Row key={it.id} .../>)    // id stable to the data

WHEN AN INDEX IS ACCEPTABLE: a STATIC list that is never reordered and
never inserted/deleted in the middle.

EXPLANATION: the key is the IDENTITY used in child-list reconciliation. A
correct key -> React matches old and new elements correctly -> preserves
state + minimal patching.'
WHERE id='n_rc_keys';

-- ĐÀO SÂU React (đợt 4c): Context, State management, Patterns, Server data
UPDATE kg_nodes SET
description=
'Context truyền dữ liệu xuống sâu mà KHÔNG phải chuyền props qua từng
tầng (tránh "prop drilling").

  const ThemeCtx = createContext("light");

  function App() {
    return (
      <ThemeCtx.Provider value={theme}>
        <Toolbar />          {/* Toolbar không cần nhận/chuyền theme */}
      </ThemeCtx.Provider>
    );
  }
  function DeepButton() {
    const theme = useContext(ThemeCtx);   // lấy trực tiếp, dù ở rất sâu
  }

CẢNH BÁO HIỆU NĂNG: khi value của Provider ĐỔI, MỌI component dùng
useContext đó đều re-render.
  ✗ value={{ user, setUser }}            // object mới MỖI render -> render lan
  ✓ const value = useMemo(() => ({ user, setUser }), [user]);
    <Ctx.Provider value={value}>          // reference ổn định

DÙNG ĐÚNG: dữ liệu "toàn cục nhẹ", đổi ÍT — theme, locale, user đăng
nhập, config. KHÔNG dùng Context như state management cho dữ liệu đổi
liên tục (dùng store chuyên: Redux/Zustand) vì sẽ render lan diện rộng.

GIẢI THÍCH: Context giải bài prop drilling, KHÔNG phải công cụ tối ưu
render. Tách nhiều context nhỏ theo tần suất đổi để giảm render thừa.'
,description_en=
'Context passes data deep down WITHOUT threading props through every level
(avoiding "prop drilling").

  const ThemeCtx = createContext("light");

  function App() {
    return (
      <ThemeCtx.Provider value={theme}>
        <Toolbar />          {/* Toolbar need not receive/forward theme */}
      </ThemeCtx.Provider>
    );
  }
  function DeepButton() {
    const theme = useContext(ThemeCtx);   // read directly, however deep
  }

PERFORMANCE WARNING: when the Provider value CHANGES, EVERY component using
that useContext re-renders.
  ✗ value={{ user, setUser }}            // new object EACH render -> renders spread
  ✓ const value = useMemo(() => ({ user, setUser }), [user]);
    <Ctx.Provider value={value}>          // stable reference

USE IT FOR: "light global" data that changes RARELY - theme, locale, the
logged-in user, config. Do NOT use Context as state management for
frequently changing data (use a dedicated store: Redux/Zustand) because it
causes wide re-renders.

EXPLANATION: Context solves prop drilling; it is NOT a render-optimization
tool. Split into several small contexts by change frequency to cut wasted
renders.'
WHERE id='n_rc_context';

UPDATE kg_nodes SET
description=
'Chọn NƠI lưu state theo phạm vi dùng — đừng mặc định nhét mọi thứ vào
một store toàn cục.

THANG QUYẾT ĐỊNH (từ hẹp đến rộng):
  1. Biến thường / tính được  -> KHÔNG cần state (derive lúc render):
     const fullName = first + " " + last;   // đừng useState cho cái này
  2. Chỉ 1 component dùng      -> useState / useReducer cục bộ.
  3. Vài component gần nhau    -> "lift state up" lên cha chung + props.
  4. Nhiều nơi xa, đổi ít      -> Context (theme, user, locale).
  5. State SERVER (từ API)     -> React Query/SWR (KHÔNG phải state UI!).
  6. State client toàn cục phức tạp -> Redux Toolkit / Zustand / Jotai.

SAI LẦM KINH ĐIỂN: nhét dữ liệu server (list, chi tiết) vào Redux rồi tự
lo loading/cache/refetch. -> Dùng React Query: nó lo cache, dedupe,
revalidate, loading/error sẵn.

useReducer khi state phức tạp, nhiều hành động liên quan:
  const [state, dispatch] = useReducer(reducer, initial);
  dispatch({ type: "add", item });

GIẢI THÍCH: giữ state Ở GẦN nơi dùng nhất (colocation) -> ít render lan,
dễ hiểu, dễ xóa. Chỉ nâng lên global khi THỰC SỰ nhiều nơi cần.'
,description_en=
'Choose WHERE to store state by scope of use - do not default to cramming
everything into one global store.

DECISION LADDER (narrow to wide):
  1. Plain / derivable value  -> NO state needed (derive during render):
     const fullName = first + " " + last;   // do not useState for this
  2. Used by 1 component      -> local useState / useReducer.
  3. A few nearby components  -> "lift state up" to a common parent + props.
  4. Many distant places, rarely changing -> Context (theme, user, locale).
  5. SERVER state (from an API) -> React Query/SWR (NOT UI state!).
  6. Complex global client state -> Redux Toolkit / Zustand / Jotai.

CLASSIC MISTAKE: dumping server data (lists, details) into Redux and then
hand-managing loading/cache/refetch. -> Use React Query: it handles cache,
dedupe, revalidation, loading/error out of the box.

useReducer when state is complex with many related actions:
  const [state, dispatch] = useReducer(reducer, initial);
  dispatch({ type: "add", item });

EXPLANATION: keep state as CLOSE as possible to where it is used
(colocation) -> fewer spreading renders, easier to understand and delete.
Promote to global only when MANY places truly need it.'
WHERE id='n_rc_state_mgmt';

UPDATE kg_nodes SET
description=
'Các mẫu tổ chức component phổ biến:

1) CUSTOM HOOK (nay là cách CHÍNH để tái dùng logic có state):
   function useFetch(url) {
     const [data, setData] = useState(null);
     useEffect(() => { let a = true;
       fetch(url).then(r => r.json()).then(d => a && setData(d));
       return () => { a = false; }; }, [url]);
     return data;
   }

2) PRESENTATIONAL vs CONTAINER: tách component "hiển thị" (nhận props,
   không logic) khỏi component "lo dữ liệu/logic" -> UI dễ tái dùng, dễ test.

3) COMPOUND COMPONENTS: nhóm component phối hợp qua context nội bộ, cho
   API khai báo gọn:
   <Tabs>
     <Tabs.List><Tabs.Tab>A</Tabs.Tab></Tabs.List>
     <Tabs.Panel>...</Tabs.Panel>
   </Tabs>

4) children / render prop / slot: truyền UI vào thay vì hardcode -> linh
   hoạt, tránh render thừa (children không render lại khi cha đổi state).

CŨ (ít dùng nay): HOC (withX) và render-props từng dùng để chia sẻ logic
-> nay đa số thay bằng custom hook (gọn, tránh lồng sâu "wrapper hell").

GIẢI THÍCH: mục tiêu chung là TÁCH mối quan tâm (UI vs logic vs dữ liệu)
để tái dùng và test dễ. Chọn mẫu theo vấn đề, đừng áp máy móc.'
,description_en=
'Common component-organization patterns:

1) CUSTOM HOOK (now the MAIN way to reuse stateful logic):
   function useFetch(url) {
     const [data, setData] = useState(null);
     useEffect(() => { let a = true;
       fetch(url).then(r => r.json()).then(d => a && setData(d));
       return () => { a = false; }; }, [url]);
     return data;
   }

2) PRESENTATIONAL vs CONTAINER: split a "display" component (takes props,
   no logic) from a "data/logic" component -> reusable UI, easier to test.

3) COMPOUND COMPONENTS: a group of components cooperating via internal
   context, giving a clean declarative API:
   <Tabs>
     <Tabs.List><Tabs.Tab>A</Tabs.Tab></Tabs.List>
     <Tabs.Panel>...</Tabs.Panel>
   </Tabs>

4) children / render prop / slot: pass UI in instead of hardcoding it ->
   flexible, and avoids wasted renders (children do not re-render when the
   parent changes state).

OLDER (now rarer): HOCs (withX) and render-props once shared logic -> now
mostly replaced by custom hooks (cleaner, avoiding deep "wrapper hell").

EXPLANATION: the common goal is to SEPARATE concerns (UI vs logic vs data)
for reuse and testability. Pick a pattern by the problem, do not apply it
mechanically.'
WHERE id='n_rc_patterns';

UPDATE kg_nodes SET
description=
'Quản lý dữ liệu SERVER (dữ liệu từ API) khác hẳn state UI: nó là bản SAO
của server -> cần cache, đồng bộ lại, xử lý loading/error/stale.

ĐỪNG tự làm bằng useEffect + useState cho mọi thứ:
  ✗ mỗi component tự fetch -> gọi trùng, không cache, tự lo race + loading.

DÙNG React Query (TanStack Query) / SWR:
  const { data, isLoading, error } = useQuery({
    queryKey: ["user", id],
    queryFn: () => fetch(`/user/${id}`).then(r => r.json()),
  });
  // tự động: cache theo key, DEDUPE gọi trùng, refetch khi focus, retry,
  //          loading/error states, invalidate sau mutation.

MUTATION + LÀM MỚI:
  const m = useMutation({
    mutationFn: save,
    onSuccess: () => qc.invalidateQueries({ queryKey: ["user", id] }),
  });                       // sửa xong -> tự refetch dữ liệu liên quan

GIẢI THÍCH TỪNG BƯỚC:
  1. queryKey định danh dữ liệu -> cache + dedupe dựa vào nó.
  2. Nhiều component cùng key -> CHỈ một request, chia sẻ cache.
  3. Sau mutation, invalidate key -> dữ liệu tự cập nhật lại.

CỐT LÕI: tách "server state" khỏi "client/UI state". Server state giao
cho thư viện data-fetching; store toàn cục (Redux/Zustand) chỉ giữ state
UI thực sự của client.'
,description_en=
'Managing SERVER data (data from an API) is very different from UI state:
it is a COPY of the server -> it needs caching, resyncing, and
loading/error/stale handling.

DO NOT hand-roll it with useEffect + useState for everything:
  ✗ each component fetches on its own -> duplicate calls, no cache, manual
    race + loading handling.

USE React Query (TanStack Query) / SWR:
  const { data, isLoading, error } = useQuery({
    queryKey: ["user", id],
    queryFn: () => fetch(`/user/${id}`).then(r => r.json()),
  });
  // automatically: cache by key, DEDUPE duplicate calls, refetch on focus,
  //                retry, loading/error states, invalidate after a mutation.

MUTATION + REFRESH:
  const m = useMutation({
    mutationFn: save,
    onSuccess: () => qc.invalidateQueries({ queryKey: ["user", id] }),
  });                       // after saving -> auto-refetch related data

STEP BY STEP:
  1. The queryKey identifies the data -> cache + dedupe rely on it.
  2. Many components with the same key -> ONE request, shared cache.
  3. After a mutation, invalidating the key -> the data auto-refreshes.

KEY IDEA: separate "server state" from "client/UI state". Hand server state
to a data-fetching library; a global store (Redux/Zustand) should hold only
genuine client UI state.'
WHERE id='n_rc_data';

-- ĐÀO SÂU Vue (đợt 5a): Reactivity, computed/watch, Composition API, Lifecycle
UPDATE kg_nodes SET
description=
'Reactivity: Vue TỰ ĐỘNG cập nhật DOM khi dữ liệu đổi, nhờ theo dõi
(track) nơi dữ liệu được ĐỌC và kích hoạt (trigger) khi bị GHI.

ref vs reactive:
  const count = ref(0);        // bọc một GIÁ TRỊ (số, chuỗi, cả object)
  count.value++;               // trong JS phải dùng .value
  // template dùng thẳng {{ count }} (Vue tự bỏ .value)

  const state = reactive({ n: 0, user: { name: "An" } });
  state.n++;                   // KHÔNG cần .value; proxy sâu

CƠ CHẾ (Vue 3, dựa trên Proxy):
  reactive() bọc object bằng Proxy -> bẫy get để TRACK dependency, bẫy set
  để TRIGGER cập nhật. ref() dùng getter/setter trên .value.

BẪY THƯỜNG GẶP:
  ✗ mất reactivity khi destructure reactive:
     const { n } = reactive({ n: 0 });   // n thành số thường, KHÔNG reactive
  ✓ dùng toRefs: const { n } = toRefs(state);   // giữ liên kết reactive
  ✗ gán mới cả object reactive: state = {...}    // đứt Proxy
  ✓ đổi từng field, hoặc dùng ref rồi ref.value = {...}

GIẢI THÍCH TỪNG BƯỚC:
  1. Khi render đọc count.value / state.n -> Vue GHI NHỚ effect này phụ
     thuộc dữ liệu đó.
  2. Khi ghi -> Vue tìm các effect phụ thuộc -> chạy lại (cập nhật DOM).
  3. Vì theo dõi ở mức truy cập, chỉ phần THẬT SỰ dùng dữ liệu mới cập nhật.

DÙNG GÌ: ref cho giá trị đơn / đổi cả cụm; reactive cho object gom nhiều
field. Nhiều team dùng ref cho tất cả để nhất quán.'
,description_en=
'Reactivity: Vue AUTOMATICALLY updates the DOM when data changes, by
tracking where data is READ and triggering when it is WRITTEN.

ref vs reactive:
  const count = ref(0);        // wraps a VALUE (number, string, even object)
  count.value++;               // in JS you must use .value
  // the template uses {{ count }} directly (Vue unwraps .value)

  const state = reactive({ n: 0, user: { name: "An" } });
  state.n++;                   // no .value needed; deep proxy

MECHANISM (Vue 3, based on Proxy):
  reactive() wraps an object in a Proxy -> the get trap TRACKS dependencies,
  the set trap TRIGGERS updates. ref() uses a getter/setter on .value.

COMMON PITFALLS:
  ✗ losing reactivity when destructuring a reactive:
     const { n } = reactive({ n: 0 });   // n becomes a plain number, NOT reactive
  ✓ use toRefs: const { n } = toRefs(state);   // keeps the reactive link
  ✗ reassigning the whole reactive object: state = {...}   // breaks the Proxy
  ✓ change fields individually, or use a ref then ref.value = {...}

STEP BY STEP:
  1. When render reads count.value / state.n -> Vue RECORDS that this effect
     depends on that data.
  2. On a write -> Vue finds the dependent effects -> re-runs them (updates DOM).
  3. Because tracking is at access level, only the parts that actually use
     the data update.

WHAT TO USE: ref for a single value / whole-value swaps; reactive for an
object grouping many fields. Many teams use ref for everything for consistency.'
WHERE id='n_vue_reactivity';

UPDATE kg_nodes SET
description=
'computed: giá trị DẪN XUẤT, tự tính lại KHI phụ thuộc đổi, và ĐƯỢC CACHE.
watch: chạy SIDE EFFECT khi nguồn đổi.

computed (có cache — không tính lại nếu deps không đổi):
  const price = ref(100), qty = ref(2);
  const total = computed(() => price.value * qty.value);
  // total.value = 200; đọc nhiều lần KHÔNG tính lại tới khi price/qty đổi

watch (phản ứng có side effect: gọi API, lưu localStorage):
  watch(qty, (moi, cu) => {
    console.log(`qty: ${cu} -> ${moi}`);
    saveToServer(qty.value);
  });
  // watchEffect(() => ...) tự dò deps và chạy ngay lần đầu

KHI NÀO DÙNG GÌ:
  • Cần một GIÁ TRỊ tính từ state khác -> computed (khai báo, có cache).
  • Cần LÀM VIỆC khi state đổi (fetch, ghi log, thao tác ngoài) -> watch.

  ✗ dùng watch để gán một biến dẫn xuất -> nên là computed:
     watch(price, () => total.value = price.value * qty.value)  // thừa
  ✓ const total = computed(() => price.value * qty.value)

GIẢI THÍCH: computed như một "công thức" — Vue biết nó phụ thuộc gì, chỉ
tính lại đúng lúc và nhớ kết quả. watch là "khi X đổi thì làm Y". Ưu tiên
computed; chỉ dùng watch khi cần EFFECT thật sự.'
,description_en=
'computed: a DERIVED value that recomputes WHEN its dependencies change and
is CACHED. watch: runs a SIDE EFFECT when a source changes.

computed (cached - does not recompute if deps are unchanged):
  const price = ref(100), qty = ref(2);
  const total = computed(() => price.value * qty.value);
  // total.value = 200; reading it many times does NOT recompute until
  //   price/qty change

watch (reacts with a side effect: call an API, save to localStorage):
  watch(qty, (next, prev) => {
    console.log(`qty: ${prev} -> ${next}`);
    saveToServer(qty.value);
  });
  // watchEffect(() => ...) auto-detects deps and runs immediately once

WHICH TO USE:
  • Need a VALUE computed from other state -> computed (declarative, cached).
  • Need to DO WORK when state changes (fetch, log, external ops) -> watch.

  ✗ using watch to assign a derived variable -> it should be computed:
     watch(price, () => total.value = price.value * qty.value)  // redundant
  ✓ const total = computed(() => price.value * qty.value)

EXPLANATION: computed is like a "formula" - Vue knows its dependencies,
recomputes only when needed, and caches the result. watch is "when X
changes, do Y". Prefer computed; use watch only when you truly need an EFFECT.'
WHERE id='n_vue_computed';

UPDATE kg_nodes SET
description=
'Hai cách viết logic component trong Vue 3:

OPTIONS API (theo "loại" tùy chọn: data, methods, computed, watch...):
  export default {
    data() { return { count: 0 }; },
    computed: { double() { return this.count * 2; } },
    methods: { inc() { this.count++; } },
  }
  // logic của MỘT tính năng bị RẢI ra nhiều khối (data + methods + watch...)

COMPOSITION API (gom theo TÍNH NĂNG, dùng trong <script setup>):
  <script setup>
  import { ref, computed } from "vue";
  const count = ref(0);
  const double = computed(() => count.value * 2);
  function inc() { count.value++; }
  </script>
  // mọi thứ của một tính năng nằm CẠNH nhau -> dễ đọc, dễ tách

LỢI ÍCH COMPOSITION:
  • Tái dùng logic bằng COMPOSABLE (giống custom hook của React):
      function useCounter() {
        const count = ref(0);
        const inc = () => count.value++;
        return { count, inc };
      }
  • Gom logic theo tính năng (tính năng lớn không bị xé nhỏ).
  • Hợp TypeScript hơn (suy kiểu tốt, không phụ thuộc this).

KHI NÀO DÙNG: Composition cho app vừa/lớn, cần tái dùng logic. Options vẫn
ổn cho component nhỏ / người mới. Hai cách chạy trên CÙNG hệ reactivity.'
,description_en=
'Two ways to write component logic in Vue 3:

OPTIONS API (organized by option "type": data, methods, computed, watch...):
  export default {
    data() { return { count: 0 }; },
    computed: { double() { return this.count * 2; } },
    methods: { inc() { this.count++; } },
  }
  // logic for ONE feature gets SCATTERED across blocks (data + methods + watch)

COMPOSITION API (grouped by FEATURE, used in <script setup>):
  <script setup>
  import { ref, computed } from "vue";
  const count = ref(0);
  const double = computed(() => count.value * 2);
  function inc() { count.value++; }
  </script>
  // everything for a feature sits TOGETHER -> easier to read and extract

COMPOSITION BENEFITS:
  • Reuse logic via a COMPOSABLE (like a React custom hook):
      function useCounter() {
        const count = ref(0);
        const inc = () => count.value++;
        return { count, inc };
      }
  • Group logic by feature (a large feature is not torn apart).
  • Better with TypeScript (good inference, no reliance on this).

WHEN TO USE: Composition for medium/large apps needing logic reuse. Options
is still fine for small components / beginners. Both run on the SAME
reactivity system.'
WHERE id='n_vue_composition';

UPDATE kg_nodes SET
description=
'Lifecycle hooks = các mốc trong vòng đời component để chạy code đúng thời
điểm (setup DOM, fetch, dọn dẹp).

VÒNG ĐỜI (rút gọn):
  setup/created ─► onMounted ─► (cập nhật: onUpdated) ─► onUnmounted
     (chưa có DOM)   (DOM sẵn)                          (dọn dẹp)

COMPOSITION API (trong <script setup>):
  import { onMounted, onUnmounted } from "vue";
  onMounted(() => {
    // DOM đã có -> đo kích thước, khởi tạo chart, add listener
    window.addEventListener("resize", onResize);
  });
  onUnmounted(() => {
    window.removeEventListener("resize", onResize);  // DỌN để tránh rò rỉ
  });

TƯƠNG ĐƯƠNG OPTIONS API: mounted(), updated(), unmounted().

DÙNG ĐÚNG CHỖ:
  • onMounted   : việc CẦN DOM (thư viện DOM, focus input, fetch lần đầu).
  • onUnmounted : HỦY timer/listener/subscription -> tránh memory leak.
  • onUpdated   : hiếm khi cần; cẩn thận vòng lặp cập nhật vô hạn.

GIẢI THÍCH: setup chạy TRƯỚC khi có DOM (đừng chạm phần tử DOM ở đây). Cặp
onMounted/onUnmounted giống useEffect có cleanup của React — mở tài nguyên
khi vào, đóng khi rời.'
,description_en=
'Lifecycle hooks = milestones in a component life to run code at the right
moment (DOM setup, fetch, cleanup).

LIFECYCLE (condensed):
  setup/created ─► onMounted ─► (updates: onUpdated) ─► onUnmounted
     (no DOM yet)   (DOM ready)                        (cleanup)

COMPOSITION API (in <script setup>):
  import { onMounted, onUnmounted } from "vue";
  onMounted(() => {
    // the DOM exists -> measure sizes, init a chart, add a listener
    window.addEventListener("resize", onResize);
  });
  onUnmounted(() => {
    window.removeEventListener("resize", onResize);  // CLEAN to avoid leaks
  });

OPTIONS API EQUIVALENT: mounted(), updated(), unmounted().

USE THE RIGHT ONE:
  • onMounted   : work that NEEDS the DOM (DOM libs, focusing an input,
    initial fetch).
  • onUnmounted : CANCEL timers/listeners/subscriptions -> avoid memory leaks.
  • onUpdated   : rarely needed; beware infinite update loops.

EXPLANATION: setup runs BEFORE the DOM exists (do not touch DOM elements
here). The onMounted/onUnmounted pair is like React useEffect with cleanup -
open resources on entry, close on leave.'
WHERE id='n_vue_lifecycle';

-- ĐÀO SÂU Vue (đợt 5b): Props/Emit/v-model, Slots, Directives, SFC
UPDATE kg_nodes SET
description=
'Giao tiếp cha-con: props đi XUỐNG (cha -> con), emit đi LÊN (con báo cha).
Dữ liệu MỘT CHIỀU: con KHÔNG sửa trực tiếp prop.

CON nhận props, phát event:
  <script setup>
  const props = defineProps({ modelValue: String });
  const emit  = defineEmits(["update:modelValue"]);
  function onInput(e) { emit("update:modelValue", e.target.value); }
  </script>

  ✗ props.modelValue = "x";   // SAI: sửa prop trực tiếp -> cảnh báo, đứt luồng
  ✓ emit lên cha để cha đổi state -> chảy lại xuống qua prop

v-model = ĐƯỜNG TẮT của (prop modelValue + event update:modelValue):
  <Child v-model="text" />
  <!-- tương đương: -->
  <Child :modelValue="text" @update:modelValue="text = $event" />

NHIỀU v-model (Vue 3):
  <Child v-model:title="t" v-model:body="b" />

GIẢI THÍCH TỪNG BƯỚC:
  1. Cha truyền dữ liệu xuống qua prop.
  2. Con muốn đổi -> EMIT event, KHÔNG tự sửa prop (one-way data flow).
  3. Cha nghe event -> cập nhật state -> prop mới chảy xuống.
  4. v-model chỉ là cú pháp gọn cho cặp prop + event đó.

Vì sao một chiều: nguồn sự thật nằm ở CHA -> dễ lần luồng dữ liệu, tránh
hai bên cùng sửa gây khó gỡ lỗi.'
,description_en=
'Parent-child communication: props go DOWN (parent -> child), emit goes UP
(child notifies parent). Data is ONE-WAY: the child does NOT mutate a prop
directly.

CHILD receives props, emits events:
  <script setup>
  const props = defineProps({ modelValue: String });
  const emit  = defineEmits(["update:modelValue"]);
  function onInput(e) { emit("update:modelValue", e.target.value); }
  </script>

  ✗ props.modelValue = "x";   // WRONG: mutating a prop -> warning, broken flow
  ✓ emit to the parent so it changes state -> flows back down via the prop

v-model = SHORTHAND for (a modelValue prop + an update:modelValue event):
  <Child v-model="text" />
  <!-- equivalent to: -->
  <Child :modelValue="text" @update:modelValue="text = $event" />

MULTIPLE v-model (Vue 3):
  <Child v-model:title="t" v-model:body="b" />

STEP BY STEP:
  1. The parent passes data down via a prop.
  2. To change it, the child EMITS an event, it does NOT mutate the prop
     (one-way data flow).
  3. The parent listens -> updates state -> the new prop flows down.
  4. v-model is just concise syntax for that prop + event pair.

Why one-way: the source of truth lives in the PARENT -> easy to trace data
flow and avoid both sides mutating (which is hard to debug).'
WHERE id='n_vue_props_emit';

UPDATE kg_nodes SET
description=
'Slot = chỗ trống để CHA nhét nội dung vào CON -> component bao bọc linh
hoạt (giống children của React).

DEFAULT SLOT:
  <!-- Card.vue -->
  <div class="card"><slot /></div>
  <!-- dùng -->
  <Card><p>Nội dung tùy ý</p></Card>   <!-- <p> thế vào <slot/> -->

NAMED SLOTS (nhiều vùng):
  <!-- Layout.vue -->
  <header><slot name="header" /></header>
  <main><slot /></main>
  <!-- dùng -->
  <Layout>
    <template #header><h1>Tiêu đề</h1></template>
    <p>Thân trang</p>
  </Layout>

SCOPED SLOT (con TRUYỀN dữ liệu ngược ra cho cha render):
  <!-- List.vue -->
  <li v-for="it in items" :key="it.id"><slot :item="it" /></li>
  <!-- dùng: cha quyết định render mỗi item -->
  <List :items="users">
    <template #default="{ item }">{{ item.name }}</template>
  </List>

GIẢI THÍCH: slot đảo quyền render — CON định nghĩa KHUNG, CHA cấp NỘI DUNG.
Scoped slot cho con "cho mượn" dữ liệu ra ngoài để cha tùy biến hiển thị
(bảng, danh sách tái dùng, component headless).'
,description_en=
'A slot = a placeholder where the PARENT injects content into the CHILD ->
flexible wrapper components (like React children).

DEFAULT SLOT:
  <!-- Card.vue -->
  <div class="card"><slot /></div>
  <!-- usage -->
  <Card><p>Any content</p></Card>   <!-- <p> replaces <slot/> -->

NAMED SLOTS (multiple regions):
  <!-- Layout.vue -->
  <header><slot name="header" /></header>
  <main><slot /></main>
  <!-- usage -->
  <Layout>
    <template #header><h1>Title</h1></template>
    <p>Page body</p>
  </Layout>

SCOPED SLOT (the child PASSES data back out for the parent to render):
  <!-- List.vue -->
  <li v-for="it in items" :key="it.id"><slot :item="it" /></li>
  <!-- usage: the parent decides how to render each item -->
  <List :items="users">
    <template #default="{ item }">{{ item.name }}</template>
  </List>

EXPLANATION: slots invert render control - the CHILD defines the FRAME, the
PARENT supplies the CONTENT. A scoped slot lets the child "lend" data out so
the parent can customize the display (tables, reusable lists, headless
components).'
WHERE id='n_vue_slots';

UPDATE kg_nodes SET
description=
'Directive = thuộc tính đặc biệt (tiền tố v-) gắn hành vi lên DOM.

CÁC DIRECTIVE LÕI:
  v-if / v-else : thêm/xóa element khỏi DOM theo điều kiện (tốn hơn khi
                  bật/tắt liên tục).
  v-show        : luôn render, chỉ đổi CSS display (rẻ khi bật/tắt nhiều).
  v-for         : lặp danh sách — LUÔN kèm :key ổn định:
      <li v-for="u in users" :key="u.id">{{ u.name }}</li>
  v-bind (:)    : bind thuộc tính -> :href="url"
  v-on   (@)    : nghe sự kiện   -> @click="save"
  v-model       : two-way binding cho input.

v-if vs v-show:
  ✗ v-show cho thứ hiếm khi hiện -> vẫn render sẵn (tốn tài nguyên).
  ✓ v-show khi bật/tắt LIÊN TỤC (tab, tooltip); v-if khi ít đổi / nặng.

  ✗ dùng CHUNG v-if và v-for trên một thẻ (ưu tiên nhập nhằng)
  ✓ tách: bọc v-if ở ngoài, hoặc lọc bằng computed trước khi v-for.

CUSTOM DIRECTIVE (khi cần thao tác DOM mức thấp):
  app.directive("focus", { mounted: (el) => el.focus() });
  <input v-focus />

GIẢI THÍCH: directive là cách Vue gắn logic KHAI BÁO lên DOM. Nhớ phân
biệt v-if (thêm/bớt node thật) vs v-show (ẩn bằng CSS) — câu hỏi phỏng vấn
rất hay gặp.'
,description_en=
'A directive = a special attribute (v- prefix) attaching behavior to the DOM.

CORE DIRECTIVES:
  v-if / v-else : add/remove an element from the DOM by condition (costlier
                  when toggled frequently).
  v-show        : always renders, only toggles CSS display (cheap for
                  frequent toggling).
  v-for         : loop a list - ALWAYS with a stable :key:
      <li v-for="u in users" :key="u.id">{{ u.name }}</li>
  v-bind (:)    : bind an attribute -> :href="url"
  v-on   (@)    : listen to an event -> @click="save"
  v-model       : two-way binding for inputs.

v-if vs v-show:
  ✗ v-show for something rarely shown -> still rendered upfront (wasteful).
  ✓ v-show for FREQUENT toggling (tabs, tooltips); v-if for rarely-changing
    / heavy content.

  ✗ combining v-if and v-for on one tag (ambiguous precedence)
  ✓ split them: wrap v-if outside, or filter with a computed before v-for.

CUSTOM DIRECTIVE (for low-level DOM work):
  app.directive("focus", { mounted: (el) => el.focus() });
  <input v-focus />

EXPLANATION: directives are how Vue attaches DECLARATIVE logic to the DOM.
Remember the difference between v-if (adds/removes real nodes) and v-show
(hides via CSS) - a very common interview question.'
WHERE id='n_vue_directives';

UPDATE kg_nodes SET
description=
'Single File Component (.vue) gói 3 phần của MỘT component vào 1 file:
template (HTML) + script (logic) + style (CSS), đặt cạnh nhau.

  <template>
    <button @click="inc">{{ count }}</button>
  </template>

  <script setup>
  import { ref } from "vue";
  const count = ref(0);
  const inc = () => count.value++;
  </script>

  <style scoped>
  button { color: teal; }   /* scoped -> CHỈ áp cho component này */
  </style>

ĐIỂM QUAN TRỌNG:
  • <script setup> : cú pháp gọn của Composition API — biến/khai báo tự
    expose ra template, KHÔNG cần return.
  • <style scoped> : Vue thêm attribute băm (data-v-xxx) -> CSS không rò rỉ
    ra component khác.
  • Build: .vue được Vite/vue-loader biên dịch sang render function JS.

VÌ SAO TỐT: mọi thứ của một component nằm CÙNG chỗ -> dễ đọc, dễ di chuyển,
dễ xóa. CSS cô lập theo component -> tránh xung đột class toàn cục.

GIẢI THÍCH: SFC là đơn vị chuẩn của app Vue. Kết hợp <script setup> +
scoped style cho component gọn gàng, an toàn CSS, và tận dụng tối ưu lúc
build (biên dịch template thành render function).'
,description_en=
'A Single File Component (.vue) packs the 3 parts of ONE component into one
file: template (HTML) + script (logic) + style (CSS), side by side.

  <template>
    <button @click="inc">{{ count }}</button>
  </template>

  <script setup>
  import { ref } from "vue";
  const count = ref(0);
  const inc = () => count.value++;
  </script>

  <style scoped>
  button { color: teal; }   /* scoped -> applies ONLY to this component */
  </style>

KEY POINTS:
  • <script setup> : concise Composition API syntax - declarations auto-expose
    to the template, NO return needed.
  • <style scoped> : Vue adds a hashed attribute (data-v-xxx) -> CSS does not
    leak into other components.
  • Build: .vue is compiled by Vite/vue-loader into a JS render function.

WHY IT IS GOOD: everything for a component lives TOGETHER -> easy to read,
move, and delete. Component-scoped CSS -> avoids global class conflicts.

EXPLANATION: the SFC is the standard unit of a Vue app. Combining
<script setup> + scoped style gives tidy components, CSS safety, and
build-time optimization (compiling the template into a render function).'
WHERE id='n_vue_sfc';

-- ĐÀO SÂU Vue (đợt 5c): Pinia, Perf, Vue vs React
UPDATE kg_nodes SET
description=
'Pinia = store quản lý state TOÀN CỤC chính thức của Vue (thay Vuex). Dùng
khi nhiều component xa nhau cần chia sẻ / đổi cùng một state.

ĐỊNH NGHĨA STORE:
  export const useCounter = defineStore("counter", () => {
    const count  = ref(0);                          // state
    const double = computed(() => count.value * 2); // getter
    function inc() { count.value++; }               // action
    return { count, double, inc };
  });

DÙNG trong component:
  const c = useCounter();
  c.inc();  c.count;  c.double;
  // muốn destructure mà giữ reactivity:
  const { count, double } = storeToRefs(c);   // state/getter -> giữ reactive
  const { inc } = c;                           // action lấy thẳng được

VÌ SAO PINIA (so Vuex cũ):
  • API gọn, KHÔNG mutations rườm rà; hợp Composition API + TypeScript.
  • Modular tự nhiên: mỗi store một file, tự tách nhỏ.
  • Devtools + hỗ trợ SSR sẵn.

KHI NÀO CẦN: state DÙNG CHUNG nhiều nơi (user đăng nhập, giỏ hàng, theme
phức tạp). State chỉ một nhánh dùng -> để cục bộ (ref/composable), đừng
nhồi hết vào store.

GIẢI THÍCH TỪNG BƯỚC:
  1. defineStore tạo một store singleton theo id.
  2. Component gọi useStore() -> nhận CÙNG một instance chia sẻ.
  3. storeToRefs giữ reactivity khi tách state ra biến rời.'
,description_en=
'Pinia = the official global state store for Vue (replacing Vuex). Use it
when many distant components must share / change the same state.

DEFINING A STORE:
  export const useCounter = defineStore("counter", () => {
    const count  = ref(0);                          // state
    const double = computed(() => count.value * 2); // getter
    function inc() { count.value++; }               // action
    return { count, double, inc };
  });

USING IT in a component:
  const c = useCounter();
  c.inc();  c.count;  c.double;
  // to destructure while keeping reactivity:
  const { count, double } = storeToRefs(c);   // state/getters -> stay reactive
  const { inc } = c;                           // actions can be taken directly

WHY PINIA (vs old Vuex):
  • Lean API, NO verbose mutations; fits Composition API + TypeScript.
  • Naturally modular: one store per file, split easily.
  • Devtools + SSR support out of the box.

WHEN NEEDED: state SHARED across many places (logged-in user, cart, complex
theme). State used by only one branch -> keep it local (ref/composable), do
not cram everything into the store.

STEP BY STEP:
  1. defineStore creates a singleton store by id.
  2. Components call useStore() -> get the SAME shared instance.
  3. storeToRefs preserves reactivity when extracting state into loose vars.'
WHERE id='n_vue_pinia';

UPDATE kg_nodes SET
description=
'Tối ưu Vue = giảm việc reactivity + render thừa. Thứ tự ưu tiên:

1) KEY ĐÚNG cho v-for (id ổn định) -> Vue tái dùng DOM đúng, patch tối
   thiểu (giống React keys):
   <li v-for="u in users" :key="u.id">

2) v-show vs v-if đúng chỗ: bật/tắt liên tục -> v-show; ít đổi/nặng -> v-if.

3) v-once / v-memo cho phần TĨNH hoặc ít đổi:
   <div v-once>...</div>            <!-- render 1 lần, không cập nhật nữa -->
   <div v-memo="[id]">...</div>     <!-- chỉ render lại khi id đổi -->

4) computed thay cho tính trong template (có cache) — đừng gọi hàm nặng
   trực tiếp trong {{ }} (chạy MỖI lần render).

5) Danh sách rất dài -> VIRTUAL SCROLL (vue-virtual-scroller): chỉ render
   phần đang thấy.

6) shallowRef / shallowReactive cho cấu trúc lớn KHÔNG cần reactivity sâu
   -> bớt chi phí theo dõi.

  ✗ {{ heavyCompute(item) }} trong template -> chạy lại mỗi render
  ✓ dùng computed hoặc tính sẵn khi dữ liệu đổi

GIẢI THÍCH: reactivity của Vue vốn đã giới hạn cập nhật ở nơi dùng dữ liệu,
nên tối ưu chủ yếu là: key đúng, tránh tính lặp trong template, cache bằng
computed, cắt render phần tĩnh/dài. Luôn ĐO bằng Vue Devtools trước khi tối ưu.'
,description_en=
'Optimizing Vue = reducing reactivity work + wasted renders. Priority order:

1) CORRECT KEY for v-for (stable id) -> Vue reuses the right DOM, minimal
   patching (like React keys):
   <li v-for="u in users" :key="u.id">

2) v-show vs v-if in the right place: frequent toggling -> v-show;
   rarely-changing/heavy -> v-if.

3) v-once / v-memo for STATIC or rarely-changing parts:
   <div v-once>...</div>            <!-- renders once, never updates again -->
   <div v-memo="[id]">...</div>     <!-- re-renders only when id changes -->

4) computed instead of computing in the template (cached) - do not call a
   heavy function directly in {{ }} (it runs on EVERY render).

5) Very long lists -> VIRTUAL SCROLL (vue-virtual-scroller): render only the
   visible portion.

6) shallowRef / shallowReactive for large structures that do NOT need deep
   reactivity -> less tracking cost.

  ✗ {{ heavyCompute(item) }} in the template -> re-runs every render
  ✓ use a computed or precompute when data changes

EXPLANATION: Vue reactivity already limits updates to where data is used, so
optimization is mainly: correct keys, avoiding repeated computation in
templates, caching via computed, and skipping renders for static/long parts.
Always MEASURE with Vue Devtools before optimizing.'
WHERE id='n_vue_perf';

UPDATE kg_nodes SET
description=
'Vue và React đều component-based + virtual DOM, khác ở CÁCH viết và CƠ CHẾ
reactivity.

  Khía cạnh        Vue                          React
  ──────────       ─────────────────────        ─────────────────────
  Template         HTML + directive (v-if,      JSX (JS thuần)
                   v-for) trong .vue
  Reactivity       TỰ ĐỘNG (Proxy track/        THỦ CÔNG (setState + so
                   trigger), ít render thừa     sánh; cần memo)
  Đổi state        gán trực tiếp: count.value++ bất biến: setCount(c=>c+1)
  Tái dùng logic   composable (useX)            custom hook (useX)
  Style            <style scoped> sẵn có         CSS-in-JS / module (ngoài)
  Đường học        thoải hơn cho người mới       linh hoạt, "JS-centric"

REACTIVITY — khác biệt cốt lõi:
  Vue:   const count = ref(0); count.value++;     // Vue tự biết ai phụ thuộc
         -> chỉ effect dùng count chạy lại, KHÔNG cần memo tay.
  React: const [c,setC]=useState(0); setC(c+1);   // render lại cả cây con
         -> phải React.memo/useMemo để chặn render thừa.

GIỐNG NHAU: component + props, dữ liệu một chiều xuống con, virtual DOM +
diff, hệ sinh thái router/store, SSR (Nuxt vs Next).

CHỌN THẾ NÀO: cả hai đều mạnh cho SPA lớn. Vue: template quen HTML,
reactivity tự động, ít boilerplate. React: hệ sinh thái + thị trường tuyển
dụng lớn hơn, JSX linh hoạt. Chọn theo team + hệ sinh thái, KHÔNG phải vì
hiệu năng (hai bên tương đương).'
,description_en=
'Vue and React are both component-based + virtual DOM, differing in how you
write them and their reactivity mechanism.

  Aspect           Vue                          React
  ──────────       ─────────────────────        ─────────────────────
  Template         HTML + directives (v-if,     JSX (plain JS)
                   v-for) in .vue
  Reactivity       AUTOMATIC (Proxy track/      MANUAL (setState +
                   trigger), fewer wasted       comparison; needs memo)
                   renders
  Changing state   direct: count.value++        immutable: setCount(c=>c+1)
  Logic reuse      composable (useX)            custom hook (useX)
  Style            <style scoped> built in      CSS-in-JS / modules (extra)
  Learning curve   gentler for beginners        flexible, "JS-centric"

REACTIVITY - the core difference:
  Vue:   const count = ref(0); count.value++;     // Vue knows who depends on it
         -> only effects using count re-run, NO manual memo needed.
  React: const [c,setC]=useState(0); setC(c+1);   // re-renders the whole subtree
         -> need React.memo/useMemo to stop wasted renders.

SIMILARITIES: components + props, one-way data flow to children, virtual
DOM + diff, router/store ecosystems, SSR (Nuxt vs Next).

HOW TO CHOOSE: both are strong for large SPAs. Vue: HTML-familiar templates,
automatic reactivity, less boilerplate. React: larger ecosystem + job
market, flexible JSX. Choose by team + ecosystem, NOT by performance (the
two are comparable).'
WHERE id='n_vue_vs_react';

-- ===== seed_english_pron =====
-- ===================================================================
--  TOPIC: Tiếng Anh Mỹ (American English) — song ngữ VI + EN, ví dụ + IPA
--  Áp: docker compose exec -T mysql \
--        mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 \
--        "$DB_NAME" < seed_english_pron.sql
--  (utf8mb4 BẮT BUỘC). File này tạo topic + 6 section + node phần Phát âm.
-- ===================================================================

INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_en','Tiếng Anh Mỹ','English',
'Tiếng Anh Mỹ (American English) toàn diện cho người Việt: phát âm & lưu ý, chunking, ngữ pháp, 12 thì, quy tắc thêm -s/-es/-ed/-ing, động từ bất quy tắc, và mẹo nói như người bản xứ.',
'Comprehensive American English for Vietnamese learners: pronunciation and notes, chunking, grammar, the 12 tenses, spelling rules for -s/-es/-ed/-ing, irregular verbs, and tips to sound like a native.',
'[]',-600,380),

('s_en_pron','Phát âm (Pronunciation)','English',
'Phát âm giọng Mỹ: IPA, âm /r/ rhotic, flap T, schwa, trọng âm từ & câu, ngữ điệu, nối âm, âm th và các âm khó với người Việt.',
'American pronunciation: IPA, rhotic /r/, flap T, schwa, word & sentence stress, intonation, linking, the th sounds and sounds hard for Vietnamese speakers.',
'[]',-720,300),
('s_en_chunk','Chunking & Connected Speech','English',
'Nhóm ý khi nói (chunking), nhịp điệu stress-timed và các biến đổi âm khi nói liền (assimilation, elision, catenation).',
'Grouping ideas (chunking), stress-timed rhythm, and how sounds change in connected speech (assimilation, elision, catenation).',
'[]',-760,180),
('s_en_grammar','Ngữ pháp (Grammar)','English',
'Ngữ pháp cốt lõi: trật tự từ, mạo từ, danh từ, đại từ, tính/trạng từ, giới từ, modal verbs, câu điều kiện, bị động, tường thuật, câu hỏi, gerund/infinitive.',
'Core grammar: word order, articles, nouns, pronouns, adjectives/adverbs, prepositions, modal verbs, conditionals, passive, reported speech, questions, gerund/infinitive.',
'[]',-560,180),
('s_en_tenses','Các thì (12 Tenses)','English',
'12 thì tiếng Anh: bản đồ tổng quan và 4 nhóm hiện tại / quá khứ / tương lai kèm cách dùng và dấu hiệu nhận biết.',
'The 12 English tenses: an overview map and the four present / past / future groups with uses and signal words.',
'[]',-400,260),
('s_en_verbs','Động từ & Quy tắc chính tả','English',
'Quy tắc chính tả & phát âm: thêm -s/-es, -ed, -ing; động từ bất quy tắc và danh từ số nhiều bất quy tắc hay dùng.',
'Spelling & pronunciation rules: adding -s/-es, -ed, -ing; common irregular verbs and irregular plural nouns.',
'[]',-380,120),
('s_en_native','Nói như người bản xứ','English',
'Contractions/reductions, phrasal verbs, idioms, slang, fillers, small talk, collocations, khác biệt Anh-Mỹ vs Anh-Anh, và mức độ trang trọng (register).',
'Contractions/reductions, phrasal verbs, idioms, slang, fillers, small talk, collocations, American vs British differences, and register.',
'[]',-560,40),

-- ------------------------- PHÁT ÂM (leaf nodes) --------------------
('n_en_ipa','Bảng âm & IPA (giọng Mỹ)','English',
'Tiếng Anh Mỹ (General American) có ~24 phụ âm + ~15 nguyên âm, ghi bằng
ký hiệu IPA. Chính tả KHÔNG khớp âm -> học theo ÂM, đừng đọc theo mặt chữ.

NGUYÊN ÂM hay gặp (kèm ví dụ):
  /iː/ see   /ɪ/ sit   /eɪ/ say   /ɛ/ bed   /æ/ cat
  /ɑː/ father /ʌ/ cup  /ə/ about (schwa)   /ɔː/ thought
  /oʊ/ go    /ʊ/ book  /uː/ too   /aɪ/ my   /aʊ/ now   /ɔɪ/ boy

PHỤ ÂM khó với người Việt:
  /θ/ think, /ð/ this, /r/ (cong lưỡi), /v/ (khác /w/),
  /z/ zoo, /ʒ/ vision; cụm cuối /st/ /kt/ /ld/ (hay bị nuốt).

MẸO TRA CỨU: từ điển tốt (Merriam-Webster, Cambridge) đều ghi IPA +
phát âm Mỹ, bấm loa nghe được. Hãy NGHE và NHẠI (shadowing) thay vì đoán
theo chữ viết.

VÌ SAO QUAN TRỌNG: một chữ đọc nhiều kiểu (a trong cat / car / care /
about), nhiều chữ đọc một âm. Nắm IPA giúp tự học phát âm chính xác bất
kỳ từ nào.',
'General American has about 24 consonants + 15 vowels, written in IPA.
Spelling does NOT match sound -> learn by SOUND, not by letters.

COMMON VOWELS (with examples):
  /iː/ see   /ɪ/ sit   /eɪ/ say   /ɛ/ bed   /æ/ cat
  /ɑː/ father /ʌ/ cup  /ə/ about (schwa)   /ɔː/ thought
  /oʊ/ go    /ʊ/ book  /uː/ too   /aɪ/ my   /aʊ/ now   /ɔɪ/ boy

CONSONANTS hard for Vietnamese speakers:
  /θ/ think, /ð/ this, /r/ (curled tongue), /v/ (unlike /w/),
  /z/ zoo, /ʒ/ vision; final clusters /st/ /kt/ /ld/ (often dropped).

LOOKUP TIP: good dictionaries (Merriam-Webster, Cambridge) show IPA + US
audio. LISTEN and IMITATE (shadowing) instead of guessing from spelling.

WHY IT MATTERS: one letter has many sounds (a in cat / car / care /
about), many letters map to one sound. Knowing IPA lets you self-learn
the exact pronunciation of any word.',
'[]',-820,340),

('n_en_r','Âm /r/ & rhotic (rất Mỹ)','English',
'Đặc trưng LỚN NHẤT của giọng Mỹ: RHOTIC — luôn phát âm /r/ ở MỌI vị trí,
kể cả cuối từ và trước phụ âm (giọng Anh-Anh thường bỏ /r/).

  car  /kɑːr/ (Mỹ đọc rõ r; Anh: /kɑː/)
  hard /hɑːrd/   four /fɔːr/   teacher /ˈtiːtʃər/

CÁCH TẠO ÂM /r/ MỸ: cong đầu lưỡi lên (retroflex) hoặc gồng gốc lưỡi,
môi hơi tròn; đầu lưỡi KHÔNG chạm vòm miệng. Không rung như "r" tiếng Việt.

R-CONTROLLED VOWELS (nguyên âm + r, đặc trưng Mỹ):
  /ɑːr/ car   /ɔːr/ more   /ɜːr/ bird, her, work (âm "ơ-r" đặc trưng)
  /ɪr/ here   /ɛr/ air     /ʊr/ tour

MẸO: âm /ɜːr/ (bird, work, her, first) là "ơ" kéo dài + cong lưỡi suốt
âm — luyện riêng vì cực hay gặp.

LƯU Ý người Việt: đừng bỏ /r/ cuối (car không phải "ca"), và đừng rung
đầu lưỡi.',
'The BIGGEST feature of American accent: RHOTIC - /r/ is always pronounced
in EVERY position, including word-final and before consonants (British
usually drops /r/).

  car  /kɑːr/ (US pronounces r clearly; UK: /kɑː/)
  hard /hɑːrd/   four /fɔːr/   teacher /ˈtiːtʃər/

MAKING THE US /r/: curl the tongue tip up (retroflex) or bunch the tongue
back, lips slightly rounded; the tip does NOT touch the roof. It does not
trill like a Vietnamese "r".

R-CONTROLLED VOWELS (vowel + r, very American):
  /ɑːr/ car   /ɔːr/ more   /ɜːr/ bird, her, work (the signature sound)
  /ɪr/ here   /ɛr/ air     /ʊr/ tour

TIP: /ɜːr/ (bird, work, her, first) is a long "er" with the tongue curled
throughout - drill it separately, it is extremely common.

NOTE for Vietnamese: do not drop final /r/ (car is not "ca"), and do not
trill the tongue tip.',
'[]',-860,260),

('n_en_t','Flap T & các biến thể của T','English',
'Trong giọng Mỹ, chữ T giữa hai nguyên âm biến thành FLAP /ɾ/ — nghe gần
như /d/ búng nhanh. Đây là lý do nghe người Mỹ nói lạ so với chữ viết.

  water  -> "wah-der"    better -> "bedder"
  city, letter, butter, party, later, matter, thirty
  cụm: "get it" -> "geddit",  "a lot of" -> "a lodda"

BỐN BIẾN THỂ CỦA T:
  1. Flap T (nguyên âm _T_ nguyên âm): water, later -> /ɾ/ (như d nhanh)
  2. Glottal stop T (trước /n/ hoặc cuối âm tiết): button, kitten,
     mountain -> nín hơi ở cổ họng, không bật /t/ rõ
  3. T bị nuốt sau N: "interview" -> "innerview", "twenty" -> "twenny"
  4. T rõ ràng: đầu từ hoặc trong âm nhấn (top, time, reTURN, aTTEND)

MẸO: người Anh-Anh vẫn bật /t/ rõ (water /ˈwɔːtə/). Luyện flap T giúp
giọng Mỹ tự nhiên hơn hẳn, và nghe hiểu nhanh hơn.',
'In American English, T between two vowels becomes a FLAP /ɾ/ - it sounds
almost like a quick /d/. This is why American speech sounds unlike its
spelling.

  water  -> "wah-der"    better -> "bedder"
  city, letter, butter, party, later, matter, thirty
  phrases: "get it" -> "geddit",  "a lot of" -> "a lodda"

FOUR VARIANTS OF T:
  1. Flap T (vowel _T_ vowel): water, later -> /ɾ/ (like a fast d)
  2. Glottal stop T (before /n/ or at syllable end): button, kitten,
     mountain -> a catch in the throat, no clear /t/ burst
  3. T dropped after N: "interview" -> "innerview", "twenty" -> "twenny"
  4. Clear T: word-initial or in a stressed syllable (top, time, reTURN)

TIP: British keeps a clear /t/ (water /ˈwɔːtə/). Practicing the flap T
makes an American accent far more natural and speeds up listening.',
'[]',-900,200),

('n_en_schwa','Schwa /ə/ & giảm âm','English',
'Schwa /ə/ là nguyên âm PHỔ BIẾN NHẤT tiếng Anh — âm "ơ" ngắn, yếu, nằm ở
âm tiết KHÔNG nhấn. Đây là chìa khóa của nhịp điệu tiếng Anh.

  about /əˈbaʊt/    banana /bəˈnænə/ (hai chữ a thành schwa)
  problem, sofa, support, the, a, to, of, from

VOWEL REDUCTION — âm tiết không nhấn bị giảm về schwa:
  photograph  /ˈfoʊtəɡræf/     (o thứ hai -> ə)
  photographer /fəˈtɑːɡrəfər/  (trọng âm dời -> nguyên âm đổi hẳn)

FUNCTION WORDS thường đọc DẠNG YẾU (weak form) với schwa:
  to -> /tə/, for -> /fər/, and -> /ən/, of -> /əv/, can -> /kən/
  "a cup of tea" -> "a cuppa tea"

MẸO người Việt: đừng đọc RÕ mọi nguyên âm như tiếng Việt. Nhấn mạnh âm
tiết chính, NUỐT nhẹ phần còn lại về schwa -> nghe Mỹ và tự nhiên hơn.
Đọc "TO-DAY" đều nhau nghe rất cứng; đúng là "tə-DAY".',
'The schwa /ə/ is the MOST COMMON vowel in English - a short, weak "uh"
in UNSTRESSED syllables. It is the key to English rhythm.

  about /əˈbaʊt/    banana /bəˈnænə/ (both a letters become schwa)
  problem, sofa, support, the, a, to, of, from

VOWEL REDUCTION - unstressed syllables reduce to schwa:
  photograph  /ˈfoʊtəɡræf/     (second o -> ə)
  photographer /fəˈtɑːɡrəfər/  (stress shifts -> the vowel changes entirely)

FUNCTION WORDS often take a WEAK FORM with schwa:
  to -> /tə/, for -> /fər/, and -> /ən/, of -> /əv/, can -> /kən/
  "a cup of tea" -> "a cuppa tea"

TIP for Vietnamese: do not pronounce every vowel fully like in Vietnamese.
Stress the main syllable and SWALLOW the rest into schwa -> more American
and natural. Saying "TO-DAY" evenly sounds stiff; it should be "tə-DAY".',
'[]',-820,140),

('n_en_wordstress','Trọng âm từ (Word Stress)','English',
'Mỗi từ nhiều âm tiết có MỘT âm tiết nhấn: đọc TO hơn, DÀI hơn, RÕ hơn.
Nhấn sai chỗ -> người Mỹ khó hiểu dù bạn phát âm đúng từng âm.

  ˈTA-ble   com-ˈPU-ter   ˈbeau-ti-ful   un-der-ˈSTAND

QUY TẮC HAY DÙNG (không tuyệt đối):
  • Danh/tính từ 2 âm tiết -> thường nhấn ĐẦU: TA-ble, HAP-py
  • Động từ 2 âm tiết -> thường nhấn SAU: re-LAX, de-CIDE
  • Cặp danh/động cùng chữ: ˈRE-cord (n) / re-ˈCORD (v),
    ˈPRE-sent (n) / pre-ˈSENT (v)
  • Đuôi -tion/-sion/-ic/-ical -> nhấn âm NGAY TRƯỚC đuôi:
    in-for-MA-tion, de-CI-sion, e-co-NO-mic
  • Đuôi -ty/-cy/-phy/-gy -> nhấn âm thứ 3 từ cuối:
    pho-TO-gra-phy, de-MO-cra-cy, a-BI-li-ty

MẸO: học từ mới là học LUÔN trọng âm (dấu ˈ đứng trước âm nhấn trong từ
điển). Âm không nhấn giảm về schwa.',
'Every multi-syllable word has ONE stressed syllable: LOUDER, LONGER,
CLEARER. Wrong stress -> Americans struggle to understand even if each
sound is correct.

  ˈTA-ble   com-ˈPU-ter   ˈbeau-ti-ful   un-der-ˈSTAND

USEFUL RULES (not absolute):
  • 2-syllable nouns/adjectives -> usually stress the FIRST: TA-ble, HAP-py
  • 2-syllable verbs -> usually stress the SECOND: re-LAX, de-CIDE
  • Noun/verb pairs spelled the same: ˈRE-cord (n) / re-ˈCORD (v),
    ˈPRE-sent (n) / pre-ˈSENT (v)
  • Endings -tion/-sion/-ic/-ical -> stress the syllable JUST BEFORE:
    in-for-MA-tion, de-CI-sion, e-co-NO-mic
  • Endings -ty/-cy/-phy/-gy -> stress the 3rd syllable from the end:
    pho-TO-gra-phy, de-MO-cra-cy, a-BI-li-ty

TIP: learning a new word means learning its stress too (the ˈ mark
precedes the stressed syllable in dictionaries). Unstressed syllables
reduce to schwa.',
'[]',-760,90),

('n_en_sentencestress','Trọng âm câu & nhịp điệu','English',
'Tiếng Anh là ngôn ngữ STRESS-TIMED: nhấn CONTENT WORDS (từ mang nghĩa),
lướt nhanh FUNCTION WORDS (từ ngữ pháp). Khoảng cách giữa các từ nhấn
gần như ĐỀU nhau về thời gian.

  CONTENT (nhấn): danh từ, động từ chính, tính từ, trạng từ, từ WH
  FUNCTION (lướt): a/the, to/of/in, and/but, đại từ, trợ động từ, be

  "I want to GO to the STORE to BUY some MILK."
   -> nhấn GO, STORE, BUY, MILK; phần còn lại lướt nhanh + schwa.

CONTRASTIVE STRESS — đổi chỗ nhấn đổi hàm ý:
  "I didn''t say he stole it."
   nhấn I  = không phải tôi nói;  nhấn STOLE = anh ta không TRỘM mà...

MẸO người Việt: tiếng Việt đọc mọi tiếng gần đều nhau; tiếng Anh KHÔNG.
Kéo dài từ nhấn, nuốt từ nối -> tạo nhịp điệu Mỹ. Đây là yếu tố SỐ 1 để
nghe tự nhiên, quan trọng hơn cả phát âm từng âm.',
'English is STRESS-TIMED: stress CONTENT WORDS (meaning), rush through
FUNCTION WORDS (grammar). The gaps between stressed words are roughly
EQUAL in time.

  CONTENT (stressed): nouns, main verbs, adjectives, adverbs, WH-words
  FUNCTION (rushed): a/the, to/of/in, and/but, pronouns, auxiliaries, be

  "I want to GO to the STORE to BUY some MILK."
   -> stress GO, STORE, BUY, MILK; the rest is fast + schwa.

CONTRASTIVE STRESS - moving the stress changes the implication:
  "I didn''t say he stole it."
   stress I  = it was not me who said it;  stress STOLE = he did not STEAL
   it (but did something else)...

TIP for Vietnamese: Vietnamese gives every syllable near-equal weight;
English does NOT. Lengthen stressed words, swallow linkers -> American
rhythm. This is the NUMBER 1 factor for sounding natural, more than
individual sounds.',
'[]',-680,60),

('n_en_intonation','Ngữ điệu (Intonation)','English',
'Ngữ điệu = lên/xuống cao độ giọng, truyền cảm xúc và báo kiểu câu. Sai
ngữ điệu nghe máy móc hoặc bị hiểu nhầm thái độ.

MẪU CƠ BẢN:
  • Xuống cuối câu: câu kể, câu hỏi WH (hỏi thông tin)
      "I live in Boston."      "Where do you live?"
  • Lên cuối câu: câu hỏi Yes/No, ý chưa xong, xác nhận
      "Are you coming?"        "So... (còn tiếp)"
  • Lên rồi xuống khi liệt kê:
      "I bought apples, oranges, and pears."  (lên ở giữa, xuống ở cuối)

UPTALK: lên giọng cuối câu KỂ nghe thiếu tự tin / như hỏi lại -> tránh
khi muốn tỏ ra chắc chắn.

CHỨC NĂNG CẢM XÚC: cùng chữ "Really?" — lên cao = ngạc nhiên; xuống thấp
= chán/nghi ngờ. "Fine." xuống gắt = KHÔNG ổn thật.

MẸO: nghe và NHẠI nguyên câu (shadowing) cả giai điệu, không chỉ từ. Ghi
âm rồi so sánh. Ngữ điệu + trọng âm câu quyết định độ tự nhiên.',
'Intonation = the rising/falling pitch of the voice; it carries emotion
and signals the sentence type. Wrong intonation sounds robotic or is
misread as an attitude.

BASIC PATTERNS:
  • Falling at the end: statements, WH-questions (asking for info)
      "I live in Boston."      "Where do you live?"
  • Rising at the end: Yes/No questions, unfinished thoughts, checking
      "Are you coming?"        "So... (to be continued)"
  • Rise then fall when listing:
      "I bought apples, oranges, and pears."  (rise mid, fall at end)

UPTALK: rising at the end of a STATEMENT sounds unsure / like a question
-> avoid it when you want to sound certain.

EMOTIONAL FUNCTION: the same "Really?" - high rise = surprise; low fall =
bored/doubtful. A sharp falling "Fine." means it is NOT fine.

TIP: listen and IMITATE whole sentences (shadowing), the melody too, not
just words. Record and compare. Intonation + sentence stress determine how
natural you sound.',
'[]',-620,120),

('n_en_linking','Nối âm (Linking)','English',
'Người Mỹ NỐI các từ khi nói, không tách rời từng chữ -> nghe thành chuỗi
liền. Đây là lý do "đọc thì hiểu mà nghe không kịp".

CÁC KIỂU NỐI:
  1. Phụ âm + nguyên âm: "an apple" -> "a-napple", "turn it on" -> "tur-ni-ton"
  2. Nguyên âm + nguyên âm (chèn /w/ hoặc /j/):
     "go on" -> "gow-on",  "I am" -> "I-yam"
  3. Hai phụ âm giống nhau -> giữ một: "this Saturday" -> "thi-Saturday"
  4. /t/,/d/ + /y/ -> hòa âm: "want you" -> "wanchu", "did you" -> "dijou"

VÍ DỤ chuỗi:
  "What are you doing?" -> "Wha-da-ya-doin?"
  "Give it up"          -> "Gi-vi-dup"

MẸO NGHE: luyện nghe theo CỤM (chunk), đừng cố tách từng từ. MẸO NÓI:
tập nối để miệng quen -> nói trôi hơn và nghe tốt hơn vì hiểu cách âm
biến đổi. Gắn chặt với connected speech.',
'Americans LINK words when speaking, not word by word -> it becomes one
stream. This is why "I can read it but cannot catch it when spoken".

TYPES OF LINKING:
  1. Consonant + vowel: "an apple" -> "a-napple", "turn it on" -> "tur-ni-ton"
  2. Vowel + vowel (insert /w/ or /j/):
     "go on" -> "gow-on",  "I am" -> "I-yam"
  3. Two identical consonants -> keep one: "this Saturday" -> "thi-Saturday"
  4. /t/,/d/ + /y/ -> blend: "want you" -> "wanchu", "did you" -> "dijou"

STREAM EXAMPLES:
  "What are you doing?" -> "Wha-da-ya-doin?"
  "Give it up"          -> "Gi-vi-dup"

LISTENING TIP: train on CHUNKS, do not force word-by-word. SPEAKING TIP:
practice linking so your mouth gets used to it -> smoother speech and
better listening because you understand how sounds change. Tightly tied
to connected speech.',
'[]',-680,170),

('n_en_th','Âm th /θ/ /ð/ & âm khó','English',
'Âm /θ/ và /ð/ (chữ "th") KHÔNG có trong tiếng Việt -> người Việt hay đọc
nhầm thành /t/, /d/, /s/, /z/. Cần luyện riêng.

  /θ/ (vô thanh): think, thank, three, month, bath, both
  /ð/ (hữu thanh): this, that, the, they, mother, breathe

CÁCH TẠO ÂM: đặt ĐẦU LƯỠI chạm nhẹ giữa/hoặc sau răng trên, thổi hơi ra.
/θ/ không rung dây thanh; /ð/ rung.
  ✗ think -> "sink" hay "tink" (sai, rất hay gặp)
  ✓ đầu lưỡi ló ra chạm răng rồi mới bật "th"

CÁC ÂM KHÁC NGƯỜI VIỆT HAY NHẦM:
  • /v/ vs /w/: "vest" (răng chạm môi dưới) ≠ "west" (tròn môi)
  • cụm phụ âm cuối: "asked" /æskt/, "texts" /teksts/ — đừng nuốt
  • /z/ cuối phải RUNG: "is, was, cheese" — đừng thành /s/
  • /l/ cuối (dark L): "feel, milk" — gồng gốc lưỡi

MẸO: soi gương xem lưỡi có ló ra khi nói th không. Luyện cặp tối thiểu
(minimal pairs): think/sink, they/day, vote/... (v vs w).',
'The /θ/ and /ð/ ("th") sounds do NOT exist in Vietnamese -> learners often
swap them for /t/, /d/, /s/, /z/. Drill them separately.

  /θ/ (voiceless): think, thank, three, month, bath, both
  /ð/ (voiced): this, that, the, they, mother, breathe

HOW TO MAKE THEM: put the TONGUE TIP lightly between/behind the upper
teeth and push air out. /θ/ has no vocal-cord vibration; /ð/ vibrates.
  ✗ think -> "sink" or "tink" (a very common error)
  ✓ let the tip show against the teeth, then release "th"

OTHER SOUNDS VIETNAMESE OFTEN CONFUSE:
  • /v/ vs /w/: "vest" (teeth on lower lip) is not "west" (rounded lips)
  • final clusters: "asked" /æskt/, "texts" /teksts/ - do not drop them
  • final /z/ must VIBRATE: "is, was, cheese" - not /s/
  • dark L at end: "feel, milk" - bunch the back of the tongue

TIP: use a mirror to check the tongue shows for th. Practice minimal
pairs: think/sink, they/day, vote vs w-sounds.',
'[]',-760,230)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ===== seed_english_chunk_grammar1 =====
-- ĐĂNG KÝ node: Chunking (3) + Grammar phần 1 (word order, articles, nouns)
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('n_en_chunking','Chunking (nhóm ý)','English',
'Chunking = chia câu thành các NHÓM Ý nhỏ (thought groups) khi nói/nghe;
mỗi nhóm là một cụm nghĩa, giữa các nhóm có ngắt nhẹ. Giúp nói rõ ràng
và nghe kịp.

  Đọc một hơi -> khó hiểu. Chia nhóm:
  "When I got home / I realized / I had left my keys / at the office."
      nhóm 1         nhóm 2       nhóm 3                nhóm 4

RANH GIỚI NHÓM thường ở:
  • sau chủ ngữ dài, trước động từ
  • trước liên từ (and, but, because, when, that)
  • quanh cụm giới từ / mệnh đề quan hệ
  • tại dấu phẩy tự nhiên

TRONG MỖI NHÓM: có MỘT từ nhấn chính (thường là content word cuối), nối
âm các từ, ngữ điệu lên/xuống trọn nhóm.

MẸO: đừng cố nói cả câu dài một hơi. Nghĩ theo cụm 3-5 từ, ngắt nhẹ giữa
cụm -> nghe tự nhiên, có thời gian nghĩ, ít vấp. Khi nghe, bắt theo cụm
thay vì từng từ.',
'Chunking = splitting a sentence into small THOUGHT GROUPS when speaking or
listening; each group is one unit of meaning, with a slight pause between
groups. It makes speech clear and listening manageable.

  Said in one breath -> hard to follow. Grouped:
  "When I got home / I realized / I had left my keys / at the office."
      group 1        group 2       group 3               group 4

GROUP BOUNDARIES usually fall:
  • after a long subject, before the verb
  • before conjunctions (and, but, because, when, that)
  • around prepositional phrases / relative clauses
  • at natural commas

WITHIN EACH GROUP: one main stressed word (often the last content word),
words link together, intonation rises/falls over the whole group.

TIP: do not force a long sentence in one breath. Think in 3-5 word chunks,
pause lightly between them -> natural sound, thinking time, fewer stumbles.
When listening, catch chunks, not single words.',
'[]',-820,210),

('n_en_connected','Connected Speech','English',
'Connected speech = âm biến đổi khi các từ nối nhau trong dòng nói tự
nhiên. Hiểu nó giúp NGHE kịp người bản xứ.

CÁC HIỆN TƯỢNG CHÍNH:
  1. Linking (nối): "turn off" -> "tur-noff" (phụ âm sang nguyên âm)
  2. Assimilation (đồng hóa): âm đổi theo âm kế bên
     "handbag" -> "hambag",  "ten pounds" -> "tem pounds",
     "did you" -> "dijou",   "won''t you" -> "wonchu"
  3. Elision (nuốt âm): bỏ bớt âm cho gọn
     "next day" -> "nex day",  "comfortable" -> "comftable"
  4. Catenation + flap: "get out" -> "ge-dout"
  5. Weak forms: and -> /ən/, of -> /əv/, to -> /tə/, can -> /kən/

VÍ DỤ tổng hợp:
  "I have got to go."  -> "I gotta go."
  "Do you want to...?" -> "D''ya wanna...?"

MẸO: đây KHÔNG phải nói ẩu — người bản xứ ai cũng vậy. Học để NGHE hiểu
(kẻo tưởng họ nói từ khác) và nói cho trôi. Luyện bằng cách chép chính tả
(dictation) các đoạn hội thoại tự nhiên.',
'Connected speech = how sounds change as words join in a natural stream.
Understanding it lets you KEEP UP with native speakers.

MAIN PHENOMENA:
  1. Linking: "turn off" -> "tur-noff" (consonant into vowel)
  2. Assimilation: a sound shifts toward its neighbor
     "handbag" -> "hambag",  "ten pounds" -> "tem pounds",
     "did you" -> "dijou",   "won''t you" -> "wonchu"
  3. Elision: dropping a sound for ease
     "next day" -> "nex day",  "comfortable" -> "comftable"
  4. Catenation + flap: "get out" -> "ge-dout"
  5. Weak forms: and -> /ən/, of -> /əv/, to -> /tə/, can -> /kən/

COMBINED EXAMPLES:
  "I have got to go."  -> "I gotta go."
  "Do you want to...?" -> "D''ya wanna...?"

TIP: this is NOT sloppy speech - every native does it. Learn it to
UNDERSTAND (so you do not mishear words) and to speak smoothly. Practice
with dictation of natural dialogues.',
'[]',-860,150),

('n_en_rhythm','Nhịp điệu (Stress-timed)','English',
'Nhịp điệu tiếng Anh là STRESS-TIMED: các âm tiết NHẤN cách nhau đều đặn
về thời gian, các âm không nhấn bị nén lại cho vừa. Tiếng Việt là
SYLLABLE-TIMED (mỗi tiếng gần như đều thời lượng) -> đây là khác biệt gốc.

  "CATS eat FISH."                 (3 nhấn, thong thả)
  "The CATS will EAT the FISH."    (vẫn ~3 nhịp nhấn)
  "The CATS have EAten the FISH."  (~3 nhịp; phần yếu bị nén lại)
  -> số TỪ tăng nhưng số NHỊP NHẤN gần như giữ nguyên; từ yếu bị nuốt.

HỆ QUẢ: từ chức năng (the, have, will, to) rất ngắn và mờ; đừng cố đọc
rõ từng cái.

MẸO người Việt: tập vỗ tay vào các từ nhấn khi đọc, giữ nhịp ĐỀU, nén
phần giữa. Đây là bí quyết bỏ giọng "đều đều từng chữ" đặc trưng của
người Việt học tiếng Anh, và là gốc của trọng âm câu.',
'English rhythm is STRESS-TIMED: STRESSED syllables come at roughly equal
time intervals, and unstressed syllables get squeezed to fit. Vietnamese
is SYLLABLE-TIMED (each syllable near-equal in length) -> this is the root
difference.

  "CATS eat FISH."                 (3 stresses, leisurely)
  "The CATS will EAT the FISH."    (still ~3 stress beats)
  "The CATS have EAten the FISH."  (~3 beats; weak parts compressed)
  -> the WORD count grows but the STRESS beats stay about the same; weak
     words are swallowed.

CONSEQUENCE: function words (the, have, will, to) are very short and faint;
do not try to pronounce each fully.

TIP for Vietnamese: clap on the stressed words as you read, keep the beat
EVEN, compress the middle. This is the key to dropping the flat
syllable-by-syllable accent common to Vietnamese learners, and the basis of
sentence stress.',
'[]',-800,120),

('n_en_wordorder','Trật tự từ (Word Order)','English',
'Tiếng Anh theo trật tự SVO cố định: Chủ ngữ - Động từ - Tân ngữ. Sai
trật tự -> sai nghĩa hoặc khó hiểu (tiếng Việt linh hoạt hơn nhiều).

  S     V      O
  She   reads  books.
  I     love   you.   ("You love I" -> sai)

TRẬT TỰ MỞ RỘNG thường gặp:
  Subject + Verb + Object + Manner + Place + Time
  "She    read   the book   quietly   at home   last night."

  • Trạng từ thời gian ở CUỐI hoặc ĐẦU câu, không chen giữa V và O:
    ✗ "I saw yesterday him."   ✓ "I saw him yesterday."
  • Tính từ đứng TRƯỚC danh từ: "a red car" (không "a car red").

THỨ TỰ NHIỀU TÍNH TỪ (ý kiến - kích thước - tuổi - hình - màu - nguồn gốc
- chất liệu): "a nice big old round black Italian leather bag"
  -> ít khi dùng hết, nhưng "big red" đúng, "red big" nghe sai.

MẸO: khi bí, bám chắc S-V-O trước, rồi gắn thời gian/nơi chốn ra hai đầu
câu. Đây là khung xương của mọi câu tiếng Anh.',
'English uses a fixed SVO order: Subject - Verb - Object. Wrong order ->
wrong meaning or confusion (Vietnamese is far more flexible).

  S     V      O
  She   reads  books.
  I     love   you.   ("You love I" -> wrong)

EXTENDED ORDER (common):
  Subject + Verb + Object + Manner + Place + Time
  "She    read   the book   quietly   at home   last night."

  • Time adverbs go at the END or START, not between V and O:
    ✗ "I saw yesterday him."   ✓ "I saw him yesterday."
  • Adjectives go BEFORE the noun: "a red car" (not "a car red").

MULTIPLE-ADJECTIVE ORDER (opinion - size - age - shape - color - origin -
material): "a nice big old round black Italian leather bag"
  -> rarely used in full, but "big red" is right, "red big" sounds wrong.

TIP: when stuck, lock in S-V-O first, then attach time/place to the two
ends of the sentence. This is the skeleton of every English sentence.',
'[]',-620,210),

('n_en_articles','Mạo từ a / an / the','English',
'Mạo từ đứng trước danh từ: a/an (không xác định), the (xác định), hoặc
KHÔNG mạo từ (zero). Người Việt hay bỏ sót vì tiếng Việt không có mạo từ.

A / AN — danh từ ĐẾM ĐƯỢC, SỐ ÍT, nhắc lần đầu / nói chung:
  a book, a university (đọc /juː/ -> a), an hour (h câm -> an),
  an apple, an MBA (đọc /em/ -> an)
  -> chọn a/an theo ÂM đầu, KHÔNG theo chữ cái.

THE — vật ĐÃ XÁC ĐỊNH (cả người nói lẫn người nghe đều biết):
  "I bought a car. THE car is red."   (nhắc lần 2 -> the)
  the sun, the USA, the best, the internet; vật duy nhất / có định ngữ.

ZERO ARTICLE (không mạo từ) — danh từ số nhiều / không đếm nói CHUNG:
  "I like music."   "Cats are cute."   "She''s at school."

MẸO nhanh: danh từ đếm được số ít gần như LUÔN cần a/an/the/this/my... —
đừng để nó trơ trọi. Nói chung về cả loài -> số nhiều KHÔNG "the"
("Dogs are loyal"); thêm "the" sẽ thành nhóm cụ thể ("the dogs" = mấy con
chó kia).',
'Articles come before nouns: a/an (indefinite), the (definite), or NO
article (zero). Vietnamese learners often omit them since Vietnamese has no
articles.

A / AN - a COUNTABLE, SINGULAR noun, first mention / in general:
  a book, a university (sounds /juː/ -> a), an hour (silent h -> an),
  an apple, an MBA (sounds /em/ -> an)
  -> choose a/an by the SOUND, NOT the letter.

THE - a DEFINITE thing (both speaker and listener know which):
  "I bought a car. THE car is red."   (second mention -> the)
  the sun, the USA, the best, the internet; unique things / with a limiter.

ZERO ARTICLE - plural / uncountable nouns spoken IN GENERAL:
  "I like music."   "Cats are cute."   "She''s at school."

QUICK TIP: a singular countable noun almost ALWAYS needs a/an/the/this/my
- do not leave it bare. Speaking about a whole class -> plural with NO
"the" ("Dogs are loyal"); adding "the" makes it a specific group ("the
dogs" = those particular dogs).',
'[]',-560,240),

('n_en_nouns','Danh từ đếm được / không đếm','English',
'Danh từ chia COUNTABLE (đếm được) và UNCOUNTABLE (không đếm được) — quyết
định mạo từ, số nhiều và từ chỉ lượng.

COUNTABLE: có số ít/số nhiều, đếm bằng số.
  a dog / two dogs,  a problem / problems
UNCOUNTABLE: không số nhiều, không đi trực tiếp với a/an.
  water, rice, money, information, advice, furniture, news, homework
  ✗ "an information", "advices"   ✓ "some information", "a piece of advice"

LƯỢNG TỪ:
  • many / few   + đếm được số nhiều: many books, few people
  • much / little + không đếm được:  much time, little water
  • some / any / a lot of + cả hai

BẪY HAY GẶP (không đếm được, dù tiếng Việt tưởng đếm được):
  information, advice, knowledge, equipment, luggage, furniture,
  money, work, research  -> KHÔNG thêm s, KHÔNG "an".
  "news" nhìn như số nhiều nhưng là số ÍT: "The news is good."

MẸO: với danh từ trừu tượng / chất liệu, mặc định coi là uncountable
(some / a piece of / an amount of) cho tới khi chắc chắn nó đếm được.',
'Nouns split into COUNTABLE and UNCOUNTABLE - this decides articles,
plurals, and quantifiers.

COUNTABLE: has singular/plural, counted by number.
  a dog / two dogs,  a problem / problems
UNCOUNTABLE: no plural, no direct a/an.
  water, rice, money, information, advice, furniture, news, homework
  ✗ "an information", "advices"   ✓ "some information", "a piece of advice"

QUANTIFIERS:
  • many / few    + countable plural: many books, few people
  • much / little + uncountable:      much time, little water
  • some / any / a lot of + both

COMMON TRAPS (uncountable even though Vietnamese treats them as countable):
  information, advice, knowledge, equipment, luggage, furniture,
  money, work, research  -> NO s, NO "an".
  "news" looks plural but is SINGULAR: "The news is good."

TIP: for abstract / material nouns, default to uncountable
(some / a piece of / an amount of) until you are sure it is countable.',
'[]',-500,210)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ===== seed_english_grammar2 =====
-- ĐĂNG KÝ node: Grammar phần 2 (pronouns, adj/adv, prepositions, modals, conditionals)
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('n_en_pronouns','Đại từ (Pronouns)','English',
'Đại từ thay cho danh từ, chia theo VAI TRÒ trong câu. Nắm bảng này để
tránh lỗi cơ bản.

  Chủ ngữ  Tân ngữ  Sở hữu(adj)  Sở hữu(n)  Phản thân
  I        me       my           mine       myself
  you      you      your         yours      yourself
  he       him      his          his        himself
  she      her      her          hers       herself
  it       it       its          -          itself
  we       us       our          ours       ourselves
  they     them     their        theirs     themselves

LỖI HAY GẶP:
  ✗ "Me and him went."    ✓ "He and I went."   (chủ ngữ -> I, he)
  ✗ "between you and I"   ✓ "between you and me" (sau giới từ -> me)
  • its (sở hữu) vs it''s (= it is/has)
  • their (sở hữu) / there (nơi chốn) / they''re (= they are)

MẸO kiểm tra: bỏ bớt người kia -> "Me went" nghe sai -> dùng "I went".
Sau giới từ (to, for, with, between) LUÔN dùng dạng tân ngữ (me, him, us).',
'Pronouns replace nouns and change by ROLE in the sentence. Master this
table to avoid basic errors.

  Subject  Object  Possessive(adj) Possessive(n) Reflexive
  I        me      my              mine          myself
  you      you     your            yours         yourself
  he       him     his             his           himself
  she      her     her             hers          herself
  it       it      its             -             itself
  we       us      our             ours          ourselves
  they     them    their           theirs        themselves

COMMON ERRORS:
  ✗ "Me and him went."    ✓ "He and I went."   (subject -> I, he)
  ✗ "between you and I"   ✓ "between you and me" (after a preposition -> me)
  • its (possessive) vs it''s (= it is/has)
  • their (possessive) / there (place) / they''re (= they are)

CHECK TRICK: drop the other person -> "Me went" sounds wrong -> use "I
went". After a preposition (to, for, with, between) ALWAYS use the object
form (me, him, us).',
'[]',-500,150),

('n_en_adj_adv','Tính từ, Trạng từ & So sánh','English',
'Tính từ (adjective) bổ nghĩa DANH TỪ; trạng từ (adverb) bổ nghĩa ĐỘNG TỪ,
tính từ hoặc cả câu. Nhiều trạng từ = tính từ + -ly.

  adj: "a quick car"        "She is happy."
  adv: "He runs quickly."   (quickly bổ nghĩa cho runs)
  quick->quickly, careful->carefully, easy->easily (y->ily)
  bất quy tắc: good->well, fast->fast, hard->hard

VỊ TRÍ:
  • adj đứng trước danh từ, hoặc sau động từ nối (be, seem, look, feel,
    smell): "The soup smells good." (KHÔNG "smells well")
  • adv thường sau động từ/tân ngữ, hoặc ở đầu câu.

SO SÁNH:
  • Ngắn (1 âm tiết): -er / -est   tall -> taller -> the tallest
  • Dài (>=2 âm tiết): more / most  careful -> more careful -> most careful
  • Bất quy tắc: good/well->better->best; bad->worse->worst;
    far->farther/further
  Cấu trúc: "as tall as", "taller than", "the tallest".

LỖI: "smells well" (sai — well là trạng từ, ở đây cần good); "more taller"
(thừa — chỉ dùng MỘT cách so sánh).',
'Adjectives modify NOUNS; adverbs modify VERBS, adjectives, or whole
sentences. Many adverbs = adjective + -ly.

  adj: "a quick car"        "She is happy."
  adv: "He runs quickly."   (quickly modifies runs)
  quick->quickly, careful->carefully, easy->easily (y->ily)
  irregular: good->well, fast->fast, hard->hard

POSITION:
  • adjectives go before the noun, or after linking verbs (be, seem, look,
    feel, smell): "The soup smells good." (NOT "smells well")
  • adverbs usually follow the verb/object, or start the sentence.

COMPARISON:
  • Short (1 syllable): -er / -est   tall -> taller -> the tallest
  • Long (>=2 syllables): more / most  careful -> more careful -> most careful
  • Irregular: good/well->better->best; bad->worse->worst;
    far->farther/further
  Structures: "as tall as", "taller than", "the tallest".

ERRORS: "smells well" (wrong - well is an adverb, here you need good);
"more taller" (redundant - use only ONE comparison marker).',
'[]',-440,190),

('n_en_prepositions','Giới từ (Prepositions)','English',
'Giới từ chỉ quan hệ thời gian / nơi chốn / hướng. Rất hay sai vì KHÔNG
dịch 1-1 từ tiếng Việt -> học theo CỤM.

THỜI GIAN — in / on / at (rộng -> hẹp):
  at: giờ, thời điểm   -> at 7pm, at night, at noon
  on: ngày, thứ        -> on Monday, on July 4th, on the weekend (Mỹ)
  in: tháng/năm/mùa/buổi -> in May, in 2025, in summer, in the morning

NƠI CHỐN — at / on / in:
  at: điểm cụ thể -> at the door, at the bus stop, at home
  on: bề mặt      -> on the table, on the wall, on the 2nd floor
  in: không gian bao quanh -> in the box, in the room, in New York

HƯỚNG: to (đến), into (vào trong), onto, from, through, across, toward.

CỤM CỐ ĐỊNH (học thuộc, đừng suy luận):
  interested IN, good AT, depend ON, married TO, listen TO,
  arrive AT (nơi nhỏ) / IN (thành phố), afraid OF, responsible FOR.

MẸO: giới từ đi với động từ/tính từ là chuyện GHI NHỚ theo cụm, không
dịch. Học từ mới thì ghi CẢ cụm (vd học "good" là học luôn "good AT").',
'Prepositions show relations of time / place / direction. Very error-prone
because they do NOT translate 1-to-1 from Vietnamese -> learn them as CHUNKS.

TIME - in / on / at (broad -> narrow):
  at: clock time, moment -> at 7pm, at night, at noon
  on: days, dates        -> on Monday, on July 4th, on the weekend (US)
  in: month/year/season/part of day -> in May, in 2025, in summer, in the morning

PLACE - at / on / in:
  at: a specific point -> at the door, at the bus stop, at home
  on: a surface        -> on the table, on the wall, on the 2nd floor
  in: an enclosed space -> in the box, in the room, in New York

DIRECTION: to, into, onto, from, through, across, toward.

FIXED CHUNKS (memorize, do not reason):
  interested IN, good AT, depend ON, married TO, listen TO,
  arrive AT (small place) / IN (a city), afraid OF, responsible FOR.

TIP: verb/adjective + preposition is a matter of MEMORY as chunks, not
translation. When learning a new word, record the WHOLE chunk (learning
"good" means learning "good AT").',
'[]',-380,150),

('n_en_modals','Modal Verbs','English',
'Modal verbs (can, could, may, might, will, would, shall, should, must,
ought to) đứng TRƯỚC động từ nguyên mẫu (không "to", không chia), diễn đạt
khả năng / cho phép / nghĩa vụ / suy đoán.

  She CAN swim.   You SHOULD rest.   It MIGHT rain.
  ✗ "She can swims" / "to can"   ✓ "She can swim" (V nguyên mẫu)

Ý NGHĨA CHÍNH:
  • Khả năng:   can / could      ("I can drive")
  • Cho phép:   can / may        ("May I come in?" — trang trọng)
  • Lời khuyên: should / ought to ("You should sleep")
  • Bắt buộc:   must / have to    ("You must stop")
  • Cấm:        must not          ("You mustn''t smoke")
  • Không cần:  don''t have to    ("You don''t have to pay") <- KHÁC mustn''t!
  • Suy đoán:   must (chắc) / might, may (có thể) / can''t (không thể)
     "He must be tired." / "It might be true." / "That can''t be right."

QUÁ KHỨ suy đoán: must have + V3, might have + V3, should have + V3
  "You should have called." (đáng lẽ nên gọi mà đã không gọi)

MẸO: "must not" = CẤM; "don''t have to" = KHÔNG BẮT BUỘC — đừng lẫn hai
cái này.',
'Modal verbs (can, could, may, might, will, would, shall, should, must,
ought to) come BEFORE a bare infinitive (no "to", no conjugation) to
express possibility / permission / obligation / deduction.

  She CAN swim.   You SHOULD rest.   It MIGHT rain.
  ✗ "She can swims" / "to can"   ✓ "She can swim" (base verb)

MAIN MEANINGS:
  • Ability:     can / could      ("I can drive")
  • Permission:  can / may        ("May I come in?" - formal)
  • Advice:      should / ought to ("You should sleep")
  • Obligation:  must / have to    ("You must stop")
  • Prohibition: must not          ("You mustn''t smoke")
  • No necessity: don''t have to   ("You don''t have to pay") <- UNLIKE mustn''t!
  • Deduction:   must (certain) / might, may (possible) / can''t (impossible)
     "He must be tired." / "It might be true." / "That can''t be right."

PAST deduction: must have + V3, might have + V3, should have + V3
  "You should have called." (you ought to have called but did not)

TIP: "must not" = PROHIBITED; "don''t have to" = NOT REQUIRED - do not
confuse the two.',
'[]',-320,180),

('n_en_conditionals','Câu điều kiện (Conditionals)','English',
'Câu điều kiện (if) diễn đạt điều kiện -> kết quả. Có 4 loại chính + loại trộn.

TYPE 0 — sự thật hiển nhiên: If + hiện tại, hiện tại.
  "If you heat ice, it melts."

TYPE 1 — có thật ở tương lai: If + hiện tại đơn, will + V.
  "If it rains, I will stay home."   (khả năng có thật)

TYPE 2 — không thật ở hiện tại / giả định: If + quá khứ đơn, would + V.
  "If I were you, I would quit."     (dùng "were" cho MỌI ngôi)
  "If I had money, I would travel."  (thực tế đang không có tiền)

TYPE 3 — không thật trong quá khứ: If + had + V3, would have + V3.
  "If I had studied, I would have passed."  (thực tế đã không học)

MIXED — điều kiện quá khứ, kết quả hiện tại:
  "If I had saved money, I would be rich now."

MẸO: bậc thang LÙI THÌ: thật ở tương lai (T1) -> giả định hiện tại (T2,
lùi 1 thì) -> giả định quá khứ (T3, lùi 2 thì). Dùng "were" thay "was"
trong T2 là chuẩn trang trọng ("If I were...").',
'Conditionals (if) express a condition -> a result. There are 4 main types
plus a mixed type.

TYPE 0 - general truth: If + present, present.
  "If you heat ice, it melts."

TYPE 1 - real future: If + present simple, will + V.
  "If it rains, I will stay home."   (a real possibility)

TYPE 2 - unreal present / hypothetical: If + past simple, would + V.
  "If I were you, I would quit."     (use "were" for EVERY person)
  "If I had money, I would travel."  (in reality I have no money)

TYPE 3 - unreal past: If + had + V3, would have + V3.
  "If I had studied, I would have passed."  (in reality I did not study)

MIXED - past condition, present result:
  "If I had saved money, I would be rich now."

TIP: the tense-BACKSHIFT ladder: real future (T1) -> unreal present (T2,
back one tense) -> unreal past (T3, back two tenses). Using "were" instead
of "was" in T2 is the formal standard ("If I were...").',
'[]',-260,150)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ===== seed_english_grammar3 =====
-- ĐĂNG KÝ node: Grammar phần 3 (passive, reported speech, questions, gerund/infinitive)
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('n_en_passive','Câu bị động (Passive)','English',
'Câu bị động nhấn vào ĐỐI TƯỢNG bị tác động, không quan trọng ai làm.
Cấu trúc: be + V3 (past participle).

  Chủ động: "Someone stole my bike."
  Bị động:  "My bike was stolen (by someone)."
  -> tân ngữ (my bike) thành chủ ngữ; "by + tác nhân" là tùy chọn.

BE chia theo THÌ:
  hiện tại:    is/are + V3        "English is spoken here."
  quá khứ:     was/were + V3      "The house was built in 1990."
  hiện tại HT: has/have been + V3 "It has been done."
  tương lai:   will be + V3       "It will be finished tomorrow."
  modal:       can/should be + V3 "It must be checked."

KHI NÀO DÙNG:
  • không biết / không cần nói ai làm: "The road was closed."
  • văn phong khoa học, trang trọng:  "The sample was heated."
  • muốn nhấn vào kết quả / đối tượng.

MẸO người Việt: tiếng Việt dùng "bị/được"; tiếng Anh BẮT BUỘC be + V3
(đúng dạng V3, chú ý bất quy tắc!). Đừng lạm dụng bị động khi nói thường —
câu chủ động rõ và mạnh hơn.',
'The passive stresses the THING acted upon; who did it does not matter.
Structure: be + V3 (past participle).

  Active:  "Someone stole my bike."
  Passive: "My bike was stolen (by someone)."
  -> the object (my bike) becomes the subject; "by + agent" is optional.

BE changes by TENSE:
  present:    is/are + V3         "English is spoken here."
  past:       was/were + V3       "The house was built in 1990."
  pres. perf: has/have been + V3  "It has been done."
  future:     will be + V3        "It will be finished tomorrow."
  modal:      can/should be + V3  "It must be checked."

WHEN TO USE:
  • the doer is unknown / irrelevant: "The road was closed."
  • scientific, formal style:         "The sample was heated."
  • to focus on the result / object.

TIP for Vietnamese: Vietnamese uses "bi/duoc"; English REQUIRES be + V3
(the correct V3, mind irregulars!). Do not overuse the passive in casual
speech - the active voice is clearer and stronger.',
'[]',-240,110),

('n_en_reported','Câu tường thuật (Reported Speech)','English',
'Câu tường thuật kể lại lời người khác, KHÔNG dùng dấu ngoặc kép. Thường
phải LÙI THÌ và đổi đại từ / từ chỉ thời gian.

  Trực tiếp:   She said, "I am tired."
  Tường thuật: She said (that) she WAS tired.   (am->was, I->she)

LÙI THÌ (khi động từ tường thuật ở quá khứ: said/told):
  hiện tại đơn  -> quá khứ đơn        (am/is -> was; do -> did)
  hiện tại tiếp -> quá khứ tiếp       (is doing -> was doing)
  quá khứ đơn   -> quá khứ hoàn thành (did -> had done)
  will -> would;  can -> could;  must -> had to

ĐỔI TỪ CHỈ THỜI GIAN / NƠI CHỐN:
  now->then, today->that day, tomorrow->the next day,
  here->there, this->that, ago->before

CÂU HỎI tường thuật (dùng trật tự KHẲNG ĐỊNH; thêm if/whether cho Yes-No):
  "Where do you live?" -> She asked where I lived.
  "Are you ok?"        -> He asked if I was ok.
LỆNH -> tell somebody TO + V: "He told me to wait."

MẸO: nếu điều kể lại vẫn ĐÚNG ở hiện tại (sự thật), có thể KHÔNG lùi thì:
"She said she IS a doctor."',
'Reported speech retells what someone said WITHOUT quotation marks. It
usually needs a tense BACKSHIFT and changed pronouns / time words.

  Direct:   She said, "I am tired."
  Reported: She said (that) she WAS tired.   (am->was, I->she)

BACKSHIFT (when the reporting verb is past: said/told):
  present simple  -> past simple    (am/is -> was; do -> did)
  present cont.   -> past cont.      (is doing -> was doing)
  past simple     -> past perfect    (did -> had done)
  will -> would;  can -> could;  must -> had to

CHANGE TIME / PLACE WORDS:
  now->then, today->that day, tomorrow->the next day,
  here->there, this->that, ago->before

REPORTED QUESTIONS (use STATEMENT order; add if/whether for Yes-No):
  "Where do you live?" -> She asked where I lived.
  "Are you ok?"        -> He asked if I was ok.
COMMANDS -> tell somebody TO + V: "He told me to wait."

TIP: if the reported fact is still TRUE now, you may skip the backshift:
"She said she IS a doctor."',
'[]',-180,150),

('n_en_questions','Câu hỏi (Questions)','English',
'Câu hỏi tiếng Anh cần ĐẢO trợ động từ lên trước chủ ngữ (khác tiếng Việt
chỉ thêm từ hỏi ở cuối).

YES/NO QUESTIONS — đảo trợ động từ / be:
  "You are ready."  -> "ARE you ready?"
  "She likes tea."  -> "DOES she like tea?" (mượn do/does/did, V về nguyên mẫu)
  "They can swim."  -> "CAN they swim?"

WH- QUESTIONS — từ hỏi + trợ động từ + chủ ngữ + V:
  what, where, when, who, why, which, whose, how (+ much/many/long/often)
  "Where DO you live?"   "What DID she say?"   "How long HAVE you waited?"
  • Khi WH- LÀ CHỦ NGỮ -> KHÔNG đảo, không do:
    "Who called you?"  (không "Who did call you")

TAG QUESTIONS — hỏi đuôi xác nhận (mệnh đề khẳng định + đuôi phủ định,
và ngược lại):
  "You''re coming, aren''t you?"   "She can''t swim, can she?"
  "He works here, doesn''t he?"

MẸO người Việt: lỗi phổ biến là QUÊN do/does/did. "You like coffee?" ->
chuẩn hơn là "DO you like coffee?". Trong Yes/No và WH- (trừ khi WH là chủ
ngữ), luôn cần trợ động từ đảo lên trước.',
'English questions need the auxiliary INVERTED before the subject (unlike
Vietnamese, which just adds a question word at the end).

YES/NO QUESTIONS - invert the auxiliary / be:
  "You are ready."  -> "ARE you ready?"
  "She likes tea."  -> "DOES she like tea?" (borrow do/does/did; base verb)
  "They can swim."  -> "CAN they swim?"

WH- QUESTIONS - question word + auxiliary + subject + verb:
  what, where, when, who, why, which, whose, how (+ much/many/long/often)
  "Where DO you live?"   "What DID she say?"   "How long HAVE you waited?"
  • When the WH- word IS THE SUBJECT -> NO inversion, no do:
    "Who called you?"  (not "Who did call you")

TAG QUESTIONS - a confirmation tag (positive clause + negative tag, and
vice versa):
  "You''re coming, aren''t you?"   "She can''t swim, can she?"
  "He works here, doesn''t he?"

TIP for Vietnamese: a common error is FORGETTING do/does/did. "You like
coffee?" -> better as "DO you like coffee?". In Yes/No and WH- questions
(unless WH is the subject), you always need the inverted auxiliary.',
'[]',-120,110),

('n_en_gerund_inf','Gerund vs Infinitive','English',
'Sau một động từ, động từ thứ hai ở dạng V-ing (gerund) hay to-V
(infinitive)? Đây là lỗi rất hay gặp — phần lớn phải HỌC THEO động từ đứng trước.

THEO SAU LÀ V-ING (gerund):
  enjoy, avoid, finish, mind, suggest, keep, practice, consider,
  admit, deny  + sau GIỚI TỪ (good at swimming, interested in learning)
  "I enjoy reading."   "He avoided answering."

THEO SAU LÀ TO + V (infinitive):
  want, need, decide, hope, plan, promise, agree, offer, learn, would like
  "I want to go."   "She decided to stay."

ĐỔI NGHĨA tùy dạng:
  • stop doing (bỏ hẳn) vs stop to do (dừng LẠI để làm việc khác):
    "He stopped smoking." (bỏ thuốc) / "He stopped to smoke." (dừng để hút)
  • remember doing (nhớ đã làm) vs remember to do (nhớ phải làm):
    "I remember locking the door." / "Remember to lock the door."

CHỦ NGỮ đầu câu -> dùng V-ing: "Swimming is fun."

MẸO: động từ chỉ Ý ĐỊNH / TƯƠNG LAI (want, plan, hope) -> to V; động từ
chỉ việc ĐANG/ĐÃ diễn ra hay sở thích (enjoy, avoid, finish) -> V-ing.
Sau GIỚI TỪ luôn dùng V-ing.',
'After one verb, is the second verb V-ing (gerund) or to-V (infinitive)?
This is a very common error - mostly you must LEARN it by the preceding verb.

FOLLOWED BY V-ING (gerund):
  enjoy, avoid, finish, mind, suggest, keep, practice, consider,
  admit, deny  + after any PREPOSITION (good at swimming, interested in learning)
  "I enjoy reading."   "He avoided answering."

FOLLOWED BY TO + V (infinitive):
  want, need, decide, hope, plan, promise, agree, offer, learn, would like
  "I want to go."   "She decided to stay."

MEANING CHANGES by form:
  • stop doing (quit) vs stop to do (pause IN ORDER to do something else):
    "He stopped smoking." (quit) / "He stopped to smoke." (paused to smoke)
  • remember doing (recall having done) vs remember to do (not forget to):
    "I remember locking the door." / "Remember to lock the door."

A SUBJECT at the start -> use V-ing: "Swimming is fun."

TIP: verbs of INTENTION / FUTURE (want, plan, hope) -> to V; verbs of an
ongoing/past action or preference (enjoy, avoid, finish) -> V-ing. After a
PREPOSITION, always use V-ing.',
'[]',-60,150)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ===== seed_english_tenses =====
-- ĐĂNG KÝ node: Tenses (map + present group + past group + future group)
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('n_en_tenses_map','Bản đồ 12 thì','English',
'12 thì = 3 mốc thời gian (Hiện tại / Quá khứ / Tương lai) × 4 dạng
(Simple / Continuous / Perfect / Perfect Continuous).

BẢNG 12 THÌ (dạng khẳng định, động từ "do"):
             SIMPLE      CONTINUOUS        PERFECT            PERFECT CONT.
  PRESENT    do/does     am/is/are doing   have/has done      have/has been doing
  PAST       did         was/were doing    had done           had been doing
  FUTURE     will do     will be doing     will have done     will have been doing

Ý NGHĨA MỖI DẠNG:
  • Simple            : sự thật, thói quen, hành động trọn vẹn.
  • Continuous        : đang diễn ra tại một thời điểm (tạm thời, chưa xong).
  • Perfect           : nối 2 mốc — việc XONG TRƯỚC mốc đang nói.
  • Perfect Continuous: nhấn KHOẢNG kéo dài tới mốc đó.

TRỤC THỜI GIAN:
  QUÁ KHỨ ────────── HIỆN TẠI ────────── TƯƠNG LAI
   had done          have done           will have done   (perfect: xong TRƯỚC mốc)
   was doing         am doing            will be doing    (cont: đang tại mốc)

MẸO: đừng học 12 thì rời rạc. Nhớ 2 câu hỏi: (1) MỐC nào? (2) trọn vẹn /
đang diễn ra / đã xong trước / kéo dài? Ghép lại ra đúng thì. Chi tiết ở
các node hiện tại / quá khứ / tương lai.',
'The 12 tenses = 3 time frames (Present / Past / Future) x 4 aspects
(Simple / Continuous / Perfect / Perfect Continuous).

TABLE OF 12 TENSES (affirmative, verb "do"):
             SIMPLE      CONTINUOUS        PERFECT            PERFECT CONT.
  PRESENT    do/does     am/is/are doing   have/has done      have/has been doing
  PAST       did         was/were doing    had done           had been doing
  FUTURE     will do     will be doing     will have done     will have been doing

MEANING OF EACH ASPECT:
  • Simple            : facts, habits, complete actions.
  • Continuous        : in progress at a point in time (temporary, unfinished).
  • Perfect           : links 2 points - DONE BEFORE the point in question.
  • Perfect Continuous: stresses a DURATION leading up to that point.

TIMELINE:
  PAST ────────── PRESENT ────────── FUTURE
   had done       have done          will have done   (perfect: done BEFORE point)
   was doing      am doing           will be doing    (cont: happening at point)

TIP: do not learn the 12 tenses in isolation. Remember 2 questions: (1)
which TIME FRAME? (2) complete / in progress / done before / ongoing?
Combine them to get the right tense. Details in the present / past / future
nodes.',
'[]',-400,320),

('n_en_present','Nhóm Hiện tại (4 thì)','English',
'NHÓM HIỆN TẠI — 4 thì:

1) PRESENT SIMPLE (V / V-s): thói quen, sự thật, lịch trình.
   dấu hiệu: always, usually, often, every day, sometimes.
   "I work in Hanoi."  "She goes to the gym."  "Water boils at 100 C."
   (ngôi thứ 3 số ít thêm -s/-es; phủ định don''t / doesn''t)

2) PRESENT CONTINUOUS (am/is/are + V-ing): đang xảy ra LÚC NÓI, tạm thời,
   kế hoạch gần.  dấu hiệu: now, right now, at the moment, currently.
   "I am studying now."  "She is living with her parents (tạm thời)."
   Lưu ý: động từ TRẠNG THÁI (know, like, want, need) thường KHÔNG dùng -ing.

3) PRESENT PERFECT (have/has + V3): việc đã xong nhưng LIÊN QUAN hiện tại,
   hoặc kéo dài tới giờ; kinh nghiệm.
   dấu hiệu: just, already, yet, ever, never, since, for, recently.
   "I have finished."  "She has lived here for 5 years."  "Have you ever...?"
   -> KHÁC quá khứ đơn: perfect KHÔNG kèm mốc rõ (không đi với "yesterday").

4) PRESENT PERFECT CONTINUOUS (have/has been + V-ing): kéo dài liên tục
   tới hiện tại, nhấn quá trình / thời lượng.
   "I have been working since 9am."  "It has been raining all day."

MẸO người Việt: lỗi lớn nhất là QUÊN -s ngôi 3, và lạm dụng quá khứ đơn
thay cho present perfect. Có "since/for" + còn liên quan hiện tại ->
present perfect.',
'THE PRESENT GROUP - 4 tenses:

1) PRESENT SIMPLE (V / V-s): habits, facts, schedules.
   signals: always, usually, often, every day, sometimes.
   "I work in Hanoi."  "She goes to the gym."  "Water boils at 100 C."
   (3rd person singular adds -s/-es; negatives don''t / doesn''t)

2) PRESENT CONTINUOUS (am/is/are + V-ing): happening NOW, temporary, near
   plans.  signals: now, right now, at the moment, currently.
   "I am studying now."  "She is living with her parents (temporarily)."
   Note: STATE verbs (know, like, want, need) usually take NO -ing.

3) PRESENT PERFECT (have/has + V3): done but RELEVANT to now, or lasting up
   to now; experience.
   signals: just, already, yet, ever, never, since, for, recently.
   "I have finished."  "She has lived here for 5 years."  "Have you ever...?"
   -> UNLIKE past simple: the perfect takes NO specific time (not "yesterday").

4) PRESENT PERFECT CONTINUOUS (have/has been + V-ing): continuous up to now,
   stressing the process / duration.
   "I have been working since 9am."  "It has been raining all day."

TIP for Vietnamese: the biggest errors are FORGETTING 3rd-person -s, and
overusing past simple instead of present perfect. With "since/for" + still
relevant now -> present perfect.',
'[]',-460,360),

('n_en_past','Nhóm Quá khứ (4 thì)','English',
'NHÓM QUÁ KHỨ — 4 thì:

1) PAST SIMPLE (V2 / V-ed): hành động XONG trong quá khứ, có mốc rõ.
   dấu hiệu: yesterday, ago, last week, in 2010, when.
   "I visited Paris in 2019."  "She didn''t call." (phủ định did not + V)
   -> động từ bất quy tắc: go->went, see->saw, buy->bought (xem bảng riêng).

2) PAST CONTINUOUS (was/were + V-ing): đang diễn ra tại một thời điểm quá
   khứ, hoặc làm nền cho một hành động chen vào.
   "At 8pm I was having dinner."
   "I was cooking WHEN he called." (đang nấu thì bị chen ngang)

3) PAST PERFECT (had + V3): việc xong TRƯỚC một mốc / việc khác trong quá
   khứ (quá khứ của quá khứ).
   "When I arrived, the train HAD already LEFT." (tàu đi trước khi tôi tới)
   dấu hiệu: before, after, already, by the time.

4) PAST PERFECT CONTINUOUS (had been + V-ing): kéo dài liên tục tới một
   mốc quá khứ.
   "She was tired because she had been working all night."

MẸO: dùng past perfect để làm RÕ việc nào xảy ra TRƯỚC khi kể hai việc
quá khứ. Nếu đã có "before/after" chỉ rõ thứ tự thì thường past simple là
đủ. Trục: had done (xong trước) -> [mốc quá khứ] -> rồi mới...',
'THE PAST GROUP - 4 tenses:

1) PAST SIMPLE (V2 / V-ed): a COMPLETED past action with a clear time.
   signals: yesterday, ago, last week, in 2010, when.
   "I visited Paris in 2019."  "She didn''t call." (negative: did not + V)
   -> irregular verbs: go->went, see->saw, buy->bought (see the table node).

2) PAST CONTINUOUS (was/were + V-ing): in progress at a past moment, or a
   background for an interrupting action.
   "At 8pm I was having dinner."
   "I was cooking WHEN he called." (cooking, then interrupted)

3) PAST PERFECT (had + V3): done BEFORE another past point / action (the
   past of the past).
   "When I arrived, the train HAD already LEFT." (it left before I arrived)
   signals: before, after, already, by the time.

4) PAST PERFECT CONTINUOUS (had been + V-ing): continuous up to a past point.
   "She was tired because she had been working all night."

TIP: use the past perfect to make CLEAR which event came FIRST when telling
two past events. If "before/after" already shows the order, past simple is
often enough. Timeline: had done (done first) -> [past point] -> then...',
'[]',-400,380),

('n_en_future','Nhóm Tương lai','English',
'NHÓM TƯƠNG LAI — các cách diễn đạt:

1) FUTURE SIMPLE (will + V): quyết định TỨC THÌ, dự đoán, lời hứa.
   "I will help you."  "It will rain tomorrow."  "I won''t be late."

2) BE GOING TO + V: kế hoạch ĐÃ ĐỊNH trước, hoặc dự đoán có bằng chứng.
   "I am going to start a business." (đã dự tính)
   "Look at those clouds - it''s going to rain." (có dấu hiệu)
   -> will = quyết định NGAY lúc nói; going to = đã tính TỪ TRƯỚC.

3) PRESENT CONTINUOUS chỉ tương lai (sắp xếp cố định, đã hẹn):
   "I am meeting John at 6."

4) PRESENT SIMPLE cho lịch trình cố định:
   "The train leaves at 9am."

5) FUTURE CONTINUOUS (will be + V-ing): đang diễn ra tại một thời điểm
   tương lai.  "This time tomorrow I will be flying to Tokyo."

6) FUTURE PERFECT (will have + V3): sẽ XONG trước một mốc tương lai.
   "By 2030 I will have graduated."

MẸO người Việt: đừng mặc định mọi tương lai đều dùng "will". Kế hoạch có
sẵn -> "be going to" hoặc hiện tại tiếp diễn; lịch cố định -> hiện tại
đơn. Chọn đúng nghe tự nhiên hơn hẳn.',
'THE FUTURE GROUP - ways to express the future:

1) FUTURE SIMPLE (will + V): an INSTANT decision, prediction, promise.
   "I will help you."  "It will rain tomorrow."  "I won''t be late."

2) BE GOING TO + V: a plan DECIDED beforehand, or a prediction with evidence.
   "I am going to start a business." (already planned)
   "Look at those clouds - it''s going to rain." (there is evidence)
   -> will = decided AT the moment of speaking; going to = planned BEFORE.

3) PRESENT CONTINUOUS for the future (fixed arrangements, appointments):
   "I am meeting John at 6."

4) PRESENT SIMPLE for fixed timetables:
   "The train leaves at 9am."

5) FUTURE CONTINUOUS (will be + V-ing): in progress at a future moment.
   "This time tomorrow I will be flying to Tokyo."

6) FUTURE PERFECT (will have + V3): will be DONE before a future point.
   "By 2030 I will have graduated."

TIP for Vietnamese: do not default every future to "will". Prearranged
plans -> "be going to" or present continuous; fixed schedules -> present
simple. Choosing the right one sounds far more natural.',
'[]',-340,360)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ===== seed_english_verbs =====
-- ĐĂNG KÝ node: Verbs & spelling rules (-s/-es, -ed, -ing, irregular verbs, irregular plurals)
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('n_en_s_es','Quy tắc thêm -s / -es','English',
'Quy tắc thêm -s/-es dùng cho: động từ ngôi thứ 3 số ít (he/she/it) ở
hiện tại đơn, VÀ danh từ số nhiều. Cùng quy tắc chính tả + cùng cách đọc.

QUY TẮC CHÍNH TẢ:
  1. Thường: + s          work->works, book->books, play->plays
  2. Tận -s,-ss,-sh,-ch,-x,-z: + es
     watch->watches, box->boxes, kiss->kisses, wash->washes
  3. Phụ âm + y: đổi y->ies   study->studies, city->cities, try->tries
     (nguyên âm + y: giữ y + s   play->plays, boy->boys)
  4. Tận -o (một số): + es    go->goes, do->does, tomato->tomatoes
     (nhưng photo->photos, piano->pianos)

PHÁT ÂM ĐUÔI -S (3 cách — quan trọng):
  • /s/  sau âm VÔ THANH /p,t,k,f,θ/ : books, cats, laughs, stops
  • /z/  sau âm HỮU THANH + nguyên âm: dogs, plays, goes, cars, jobs
  • /ɪz/ sau âm rít /s,z,ʃ,tʃ,dʒ/    : watches, boxes, buses, changes

MẸO: đặt tay lên cổ họng — âm cuối RUNG -> đọc /z/; KHÔNG rung -> /s/; nếu
đã là âm rít thì thêm nguyên âm /ɪz/. Người Việt hay NUỐT đuôi s -> luyện
bật rõ, nhất là /z/ và /ɪz/.',
'The -s/-es rule applies to: 3rd-person singular verbs (he/she/it) in the
present simple, AND plural nouns. Same spelling rule + same pronunciation.

SPELLING RULES:
  1. Usually: + s        work->works, book->books, play->plays
  2. After -s,-ss,-sh,-ch,-x,-z: + es
     watch->watches, box->boxes, kiss->kisses, wash->washes
  3. Consonant + y: change y->ies   study->studies, city->cities, try->tries
     (vowel + y: keep y + s   play->plays, boy->boys)
  4. Some words ending -o: + es    go->goes, do->does, tomato->tomatoes
     (but photo->photos, piano->pianos)

PRONOUNCING THE -S ENDING (3 ways - important):
  • /s/  after VOICELESS sounds /p,t,k,f,θ/ : books, cats, laughs, stops
  • /z/  after VOICED sounds + vowels       : dogs, plays, goes, cars, jobs
  • /ɪz/ after sibilants /s,z,ʃ,tʃ,dʒ/      : watches, boxes, buses, changes

TIP: put a hand on your throat - a VIBRATING final sound -> /z/; NO vibration
-> /s/; already a sibilant -> add a vowel /ɪz/. Vietnamese learners often
DROP the -s -> practice releasing it clearly, especially /z/ and /ɪz/.',
'[]',-440,90),

('n_en_ed','Quy tắc thêm -ed','English',
'Quy tắc thêm -ed cho động từ CÓ QUY TẮC ở quá khứ đơn (V2) và quá khứ
phân từ (V3). Gồm quy tắc chính tả + 3 cách phát âm.

QUY TẮC CHÍNH TẢ:
  1. Thường: + ed          work->worked, play->played
  2. Tận -e: + d           like->liked, live->lived
  3. Phụ âm + y: y->ied     study->studied, try->tried  (play->played)
  4. 1 âm tiết C-V-C (phụ âm-nguyên âm-phụ âm): GẤP ĐÔI phụ âm cuối:
     stop->stopped, plan->planned, beg->begged
     (không gấp nếu tận w,x,y: fix->fixed; hoặc 2 nguyên âm: rain->rained)
  5. 2 âm tiết nhấn âm CUỐI: gấp đôi: preFER->preferred, adMIT->admitted
     (nhấn âm đầu thì không: OPen->opened)

PHÁT ÂM ĐUÔI -ED (3 cách — cực hay sai):
  • /ɪd/ sau /t/ hoặc /d/                : wanted, needed, decided (THÊM 1 âm tiết)
  • /t/  sau âm VÔ THANH /p,k,f,s,ʃ,tʃ/  : stopped, worked, washed, watched
  • /d/  sau âm HỮU THANH + nguyên âm    : played, loved, cleaned, tried

MẸO: chỉ khi gốc tận /t/ hoặc /d/ thì -ed mới thành âm tiết riêng /ɪd/.
Các trường hợp khác KHÔNG thêm âm tiết: "worked" = 1 âm tiết /wɜːrkt/, KHÔNG
đọc "work-ed". Đây là lỗi phát âm rất phổ biến của người Việt.',
'The -ed rule applies to REGULAR verbs in the past simple (V2) and past
participle (V3). It covers spelling rules + 3 pronunciations.

SPELLING RULES:
  1. Usually: + ed         work->worked, play->played
  2. Ending -e: + d        like->liked, live->lived
  3. Consonant + y: y->ied  study->studied, try->tried  (play->played)
  4. 1 syllable C-V-C (consonant-vowel-consonant): DOUBLE the final consonant:
     stop->stopped, plan->planned, beg->begged
     (no doubling after w,x,y: fix->fixed; or two vowels: rain->rained)
  5. 2 syllables stressed on the LAST: double: preFER->preferred, adMIT->admitted
     (stress on the first -> no doubling: OPen->opened)

PRONOUNCING THE -ED ENDING (3 ways - very error-prone):
  • /ɪd/ after /t/ or /d/                : wanted, needed, decided (ADDS a syllable)
  • /t/  after VOICELESS /p,k,f,s,ʃ,tʃ/  : stopped, worked, washed, watched
  • /d/  after VOICED sounds + vowels    : played, loved, cleaned, tried

TIP: only when the root ends in /t/ or /d/ does -ed become a separate
syllable /ɪd/. Otherwise it adds NO syllable: "worked" = 1 syllable
/wɜːrkt/, NOT "work-ed". This is a very common Vietnamese pronunciation error.',
'[]',-380,70),

('n_en_ing','Quy tắc thêm -ing','English',
'Quy tắc thêm -ing cho hiện tại phân từ / danh động từ (dùng trong các
thì tiếp diễn và làm gerund).

QUY TẮC CHÍNH TẢ:
  1. Thường: + ing          work->working, play->playing, see->seeing
  2. Tận -e câm: BỎ e + ing  make->making, write->writing, live->living
     (giữ e nếu -ee/-oe/-ye: see->seeing, dye->dyeing)
  3. 1 âm tiết C-V-C: GẤP ĐÔI phụ âm cuối:
     run->running, sit->sitting, stop->stopping, swim->swimming
     (không gấp nếu tận w,x,y: fix->fixing, snow->snowing)
  4. 2 âm tiết nhấn âm CUỐI: gấp đôi: beGIN->beginning, preFER->preferring
     (nhấn âm đầu thì không: LISten->listening, OPen->opening)
  5. Tận -ie -> đổi thành -ying: die->dying, lie->lying, tie->tying

VÍ DỤ SO SÁNH:
  hope->hoping (bỏ e)  nhưng  hop->hopping (gấp đôi)
  write->writing, come->coming, dance->dancing

MẸO: nhớ 2 điểm lớn — (1) BỎ "e" câm trước -ing; (2) GẤP ĐÔI phụ âm khi
1 âm tiết C-V-C để giữ nguyên âm ngắn (hopping ngắn khác hoping dài). Quy
tắc gấp đôi GIỐNG HỆT quy tắc -ed.',
'The -ing rule applies to the present participle / gerund (used in
continuous tenses and as a gerund).

SPELLING RULES:
  1. Usually: + ing          work->working, play->playing, see->seeing
  2. Silent -e: DROP e + ing  make->making, write->writing, live->living
     (keep e for -ee/-oe/-ye: see->seeing, dye->dyeing)
  3. 1 syllable C-V-C: DOUBLE the final consonant:
     run->running, sit->sitting, stop->stopping, swim->swimming
     (no doubling after w,x,y: fix->fixing, snow->snowing)
  4. 2 syllables stressed on the LAST: double: beGIN->beginning, preFER->preferring
     (stress on the first -> no doubling: LISten->listening, OPen->opening)
  5. Ending -ie -> change to -ying: die->dying, lie->lying, tie->tying

CONTRAST EXAMPLES:
  hope->hoping (drop e)  but  hop->hopping (double)
  write->writing, come->coming, dance->dancing

TIP: remember 2 big points - (1) DROP the silent "e" before -ing; (2)
DOUBLE the consonant for 1-syllable C-V-C to keep the short vowel (hopping
short vs hoping long). The doubling rule is IDENTICAL to the -ed rule.',
'[]',-320,90),

('n_en_irregular','Động từ bất quy tắc hay dùng','English',
'Động từ bất quy tắc KHÔNG thêm -ed; phải HỌC THUỘC 3 cột: V1 (nguyên mẫu)
- V2 (quá khứ) - V3 (quá khứ phân từ). Đây là các từ dùng nhiều nhất:

  V1       V2        V3         nghĩa
  be       was/were  been       thì, là
  have     had       had        có
  do       did       done       làm
  go       went      gone       đi
  get      got       gotten     lấy/trở nên (Mỹ: gotten; Anh: got)
  make     made      made       làm, tạo
  say      said      said       nói
  see      saw       seen       thấy
  come     came      come       đến
  take     took      taken      lấy, mang
  know     knew      known      biết
  give     gave      given      cho
  think    thought   thought    nghĩ
  tell     told      told       kể
  find     found     found      tìm thấy
  leave    left      left       rời đi
  bring    brought   brought    mang đến
  buy      bought    bought     mua
  eat      ate       eaten      ăn
  write    wrote     written    viết
  speak    spoke     spoken     nói
  begin    began     begun      bắt đầu
  run      ran       run        chạy

NHÓM DỄ NHỚ (theo mẫu):
  • giống cả 3: cut-cut-cut, put-put-put, let-let-let, hit-hit-hit
  • V2 = V3:    teach-taught-taught, catch-caught-caught, sleep-slept-slept
  • đổi i-a-u:  sing-sang-sung, ring-rang-rung, swim-swam-swum

MẸO: học theo NHÓM mẫu âm, ưu tiên ~50 từ hay dùng nhất. V3 dùng cho
present perfect (have + V3) và bị động (be + V3) -> sai V3 là sai cả hai.
"gotten" là dạng V3 đặc trưng Mỹ (Anh dùng "got").',
'Irregular verbs do NOT add -ed; you must MEMORIZE 3 columns: V1 (base) -
V2 (past) - V3 (past participle). These are the most-used ones:

  V1       V2        V3         meaning
  be       was/were  been       to be
  have     had       had        to have
  do       did       done       to do
  go       went      gone       to go
  get      got       gotten     get/become (US: gotten; UK: got)
  make     made      made       to make
  say      said      said       to say
  see      saw       seen       to see
  come     came      come       to come
  take     took      taken      to take
  know     knew      known      to know
  give     gave      given      to give
  think    thought   thought    to think
  tell     told      told       to tell
  find     found     found      to find
  leave    left      left       to leave
  bring    brought   brought    to bring
  buy      bought    bought     to buy
  eat      ate       eaten      to eat
  write    wrote     written    to write
  speak    spoke     spoken     to speak
  begin    began     begun      to begin
  run      ran       run        to run

EASY-TO-REMEMBER GROUPS (by pattern):
  • all three same: cut-cut-cut, put-put-put, let-let-let, hit-hit-hit
  • V2 = V3:         teach-taught-taught, catch-caught-caught, sleep-slept-slept
  • i-a-u change:    sing-sang-sung, ring-rang-rung, swim-swam-swum

TIP: learn by SOUND-PATTERN groups, prioritize the ~50 most common. V3 is
used in the present perfect (have + V3) and the passive (be + V3) -> a wrong
V3 breaks both. "gotten" is the distinctly American V3 (UK uses "got").',
'[]',-260,60),

('n_en_plural_irregular','Danh từ số nhiều bất quy tắc','English',
'Danh từ số nhiều BẤT QUY TẮC không thêm -s. Cần thuộc vì rất hay dùng.

ĐỔI NGUYÊN ÂM:
  man->men, woman->women, foot->feet, tooth->teeth, goose->geese, mouse->mice

TẬN -f/-fe -> -ves:
  leaf->leaves, wife->wives, knife->knives, life->lives, half->halves,
  wolf->wolves   (ngoại lệ: roof->roofs, chief->chiefs)

GIỮ NGUYÊN (số ít = số nhiều):
  sheep, fish, deer, series, species, aircraft
  ("fish" có "fishes" khi nói nhiều LOÀI cá)

GỐC LATIN / HY LẠP:
  child->children, person->people, ox->oxen,
  analysis->analyses, crisis->crises, phenomenon->phenomena,
  criterion->criteria, datum->data, cactus->cacti, index->indices/indexes

DANH TỪ LUÔN SỐ NHIỀU (đi với động từ số nhiều):
  scissors, glasses (kính), trousers/pants, jeans, clothes
  -> "My glasses ARE..." (không "is")

MẸO: nhóm này ít nên học thẳng. Chú ý "people" là số nhiều thường dùng
của "person", và "children" — hai từ cực kỳ hay gặp.',
'IRREGULAR plural nouns do not add -s. Learn them since they are very common.

VOWEL CHANGE:
  man->men, woman->women, foot->feet, tooth->teeth, goose->geese, mouse->mice

ENDING -f/-fe -> -ves:
  leaf->leaves, wife->wives, knife->knives, life->lives, half->halves,
  wolf->wolves   (exceptions: roof->roofs, chief->chiefs)

UNCHANGED (singular = plural):
  sheep, fish, deer, series, species, aircraft
  ("fish" has "fishes" when speaking of multiple SPECIES)

LATIN / GREEK ORIGINS:
  child->children, person->people, ox->oxen,
  analysis->analyses, crisis->crises, phenomenon->phenomena,
  criterion->criteria, datum->data, cactus->cacti, index->indices/indexes

ALWAYS-PLURAL NOUNS (take plural verbs):
  scissors, glasses, trousers/pants, jeans, clothes
  -> "My glasses ARE..." (not "is")

TIP: this set is small, so learn it directly. Note "people" is the common
plural of "person", and "children" - two extremely frequent words.',
'[]',-200,90)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ===== seed_english_native1 =====
-- ĐĂNG KÝ node: Native tips 1 (contractions, phrasal verbs, idioms, slang, fillers)
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('n_en_contractions','Contractions & Reductions','English',
'Contractions (viết tắt) và reductions (giảm âm) là ĐẶC TRƯNG của tiếng
Anh nói tự nhiên. Không dùng nghe rất cứng, trịnh trọng.

CONTRACTIONS chuẩn (dùng được cả khi viết thân mật):
  I am->I''m, you are->you''re, it is->it''s, we will->we''ll,
  I have->I''ve, do not->don''t, cannot->can''t, will not->won''t,
  did not->didn''t, is not->isn''t, she has->she''s

REDUCTIONS trong văn NÓI (không viết ở văn trang trọng):
  going to -> gonna    "I''m gonna leave."
  want to  -> wanna    "I wanna go."
  got to   -> gotta    "I gotta run."
  have to  -> hafta    "I hafta work."
  kind of  -> kinda    "It''s kinda cold."
  let me   -> lemme    "Lemme see."
  give me  -> gimme    "Gimme a sec."
  what do you -> whaddya   "Whaddya think?"

LƯU Ý QUAN TRỌNG:
  • gonna/wanna/gotta chỉ dùng khi NÓI hoặc chat, KHÔNG viết trong email /
    bài luận trang trọng.
  • "gonna" chỉ thay "going to" khi là TƯƠNG LAI; KHÔNG thay khi "going to
    + nơi chốn": "I''m going to school" (KHÔNG "gonna school").

MẸO: dùng contractions chuẩn (I''m, don''t, it''s) ở mọi văn nói/viết thân
mật -> nghe tự nhiên ngay. Reductions (gonna, wanna) để nghe hiểu và nói
casual, đừng lạm dụng khi trang trọng.',
'Contractions and reductions are HALLMARKS of natural spoken English.
Skipping them sounds stiff and overly formal.

STANDARD CONTRACTIONS (fine in informal writing too):
  I am->I''m, you are->you''re, it is->it''s, we will->we''ll,
  I have->I''ve, do not->don''t, cannot->can''t, will not->won''t,
  did not->didn''t, is not->isn''t, she has->she''s

REDUCTIONS in SPEECH (not written in formal text):
  going to -> gonna    "I''m gonna leave."
  want to  -> wanna    "I wanna go."
  got to   -> gotta    "I gotta run."
  have to  -> hafta    "I hafta work."
  kind of  -> kinda    "It''s kinda cold."
  let me   -> lemme    "Lemme see."
  give me  -> gimme    "Gimme a sec."
  what do you -> whaddya   "Whaddya think?"

IMPORTANT NOTES:
  • gonna/wanna/gotta are for SPEECH or chat only, NOT for formal emails /
    essays.
  • "gonna" replaces "going to" only for the FUTURE; NOT for "going to +
    place": "I''m going to school" (NOT "gonna school").

TIP: use standard contractions (I''m, don''t, it''s) in all informal
speech/writing -> instantly more natural. Use reductions (gonna, wanna) for
listening and casual talk, but not in formal settings.',
'[]',-620,10),

('n_en_phrasal','Phrasal Verbs','English',
'Phrasal verb = động từ + tiểu từ (giới từ/trạng từ); nghĩa thường KHÁC
hẳn nghĩa đen. Người Mỹ dùng cực nhiều trong nói hằng ngày.

  give up  = từ bỏ       "Don''t give up!"
  find out = phát hiện   "I found out the truth."
  look for = tìm kiếm    "I''m looking for my keys."
  turn on/off = bật/tắt  "Turn off the light."
  put off  = trì hoãn    "Stop putting it off."

TÁCH ĐƯỢC (separable) hay KHÔNG:
  • Separable: tân ngữ chen giữa được — "turn the light off" hoặc "turn off
    the light". Nếu tân ngữ là ĐẠI TỪ thì BẮT BUỘC chen giữa:
    "turn it off" (KHÔNG "turn off it").
  • Inseparable: không tách — "look for it" (KHÔNG "look it for").

BỘ HAY GẶP (nên thuộc): set up, work out (tập / giải quyết), come up with
(nghĩ ra), figure out (hiểu ra), get along (hòa hợp), run out of (hết),
show up (xuất hiện), bring up (nêu ra / nuôi dạy), take off (cất cánh / cởi).

MẸO: người Việt hay dùng từ trang trọng gốc Latin (investigate, cancel);
người Mỹ đời thường dùng phrasal (look into, call off). Học phrasal giúp
nghe TỰ NHIÊN và hiểu hội thoại/phim. Học theo CỤM + ví dụ, đừng dịch
từng chữ.',
'A phrasal verb = a verb + particle (preposition/adverb); the meaning is
often FAR from literal. Americans use them heavily in everyday speech.

  give up  = quit        "Don''t give up!"
  find out = discover    "I found out the truth."
  look for = search      "I''m looking for my keys."
  turn on/off = switch on/off  "Turn off the light."
  put off  = postpone    "Stop putting it off."

SEPARABLE or NOT:
  • Separable: the object can go in the middle - "turn the light off" or
    "turn off the light". If the object is a PRONOUN it MUST go in the
    middle: "turn it off" (NOT "turn off it").
  • Inseparable: cannot split - "look for it" (NOT "look it for").

COMMON SET (worth memorizing): set up, work out (exercise / resolve), come
up with (think of), figure out (understand), get along (be friendly), run
out of (deplete), show up (appear), bring up (raise / raise a child), take
off (depart / remove).

TIP: Vietnamese learners lean on formal Latin-based words (investigate,
cancel); everyday Americans use phrasals (look into, call off). Learning
phrasals makes you sound NATURAL and helps with dialogue/movies. Learn as
CHUNKS + examples, do not translate word by word.',
'[]',-680,-30),

('n_en_idioms','Idioms & Expressions','English',
'Idiom = cụm từ nghĩa BÓNG, không suy ra từ nghĩa đen. Dùng đúng nghe rất
bản xứ; dịch word-by-word sẽ sai.

THÔNG DỤNG (Mỹ):
  • piece of cake = quá dễ           "The test was a piece of cake."
  • hit the sack = đi ngủ
  • break the ice = phá tan ngại ngùng
  • under the weather = thấy không khỏe
  • cost an arm and a leg = đắt cắt cổ
  • on the same page = hiểu thống nhất
  • ballpark figure = con số ước lượng
  • no-brainer = quá hiển nhiên
  • hang in there = ráng lên, cố lên
  • cut to the chase = vào thẳng vấn đề
  • it''s not rocket science = chuyện đâu có khó
  • touch base = liên hệ, trao đổi (công sở)

MẸO: idiom rất phụ thuộc NGỮ CẢNH và mức trang trọng — dùng đúng chỗ. Khi
mới học, ưu tiên HIỂU (để nghe phim/hội thoại) hơn là cố nhồi vào lời nói.
Học vài chục idiom hay gặp trước; idiom cổ/hiếm dùng sai nghe sượng. Idiom
công sở (touch base, on the same page, ballpark figure) rất hữu ích khi đi
làm.',
'An idiom = a phrase with a FIGURATIVE meaning, not derivable from the
literal words. Used well it sounds very native; translating word-by-word
fails.

COMMON (American):
  • piece of cake = very easy         "The test was a piece of cake."
  • hit the sack = go to bed
  • break the ice = ease initial awkwardness
  • under the weather = feeling unwell
  • cost an arm and a leg = very expensive
  • on the same page = in agreement
  • ballpark figure = a rough estimate
  • no-brainer = an obvious choice
  • hang in there = keep going, stay strong
  • cut to the chase = get to the point
  • it''s not rocket science = it is not that hard
  • touch base = get in contact (workplace)

TIP: idioms depend heavily on CONTEXT and register - use them in the right
place. As a beginner, prioritize UNDERSTANDING (for movies/dialogue) over
forcing them into your speech. Learn a few dozen common ones first; obscure
or dated idioms sound off if misused. Workplace idioms (touch base, on the
same page, ballpark figure) are very useful at work.',
'[]',-620,-70),

('n_en_slang','Slang & Informal','English',
'Slang = từ lóng, RẤT thân mật, hay đổi theo thời và vùng. Hợp với bạn bè;
trong công việc / trang trọng thì TRÁNH.

SLANG MỸ phổ biến:
  • cool / awesome = tuyệt         "That''s awesome!"
  • guys = các bạn (cả nam lẫn nữ) "Hey guys!"
  • hang out = đi chơi, tụ tập
  • chill = thư giãn / bình tĩnh   "Just chill."
  • grab a bite = đi ăn nhanh
  • What''s up? / Sup? = chào, dạo này sao
  • my bad = lỗi của tớ
  • no worries / no prob = không sao
  • kinda / sorta = hơi hơi
  • legit = xịn, thật
  • bucks = đô la ("ten bucks")
  • gotcha = hiểu rồi;  y''all = các bạn (miền Nam Mỹ)

MẸO: slang giúp HÒA NHẬP và hiểu người bản xứ, nhưng (1) chỉ hợp bối cảnh
casual, (2) một số slang lỗi thời hoặc thô -> nghe nhiều rồi hẵng dùng.
Trong phỏng vấn / email công việc: dùng tiếng Anh chuẩn, tránh slang. Ranh
giới slang - idiom - informal khá mờ; cứ ưu tiên NGHE HIỂU trước khi dùng.',
'Slang = very informal vocabulary that shifts by era and region. Fine with
friends; AVOID it at work / in formal settings.

COMMON AMERICAN SLANG:
  • cool / awesome = great          "That''s awesome!"
  • guys = everyone (any gender)    "Hey guys!"
  • hang out = spend time together
  • chill = relax / calm down       "Just chill."
  • grab a bite = get a quick meal
  • What''s up? / Sup? = hi, how are things
  • my bad = my mistake
  • no worries / no prob = it is fine
  • kinda / sorta = somewhat
  • legit = genuine, great
  • bucks = dollars ("ten bucks")
  • gotcha = I understand;  y''all = you all (Southern US)

TIP: slang helps you FIT IN and understand natives, but (1) only in casual
contexts, (2) some slang is dated or crude -> hear it a lot before using it.
In interviews / work emails: use standard English, avoid slang. The
slang - idiom - informal boundaries are fuzzy; prioritize UNDERSTANDING
before producing it.',
'[]',-560,-70),

('n_en_fillers','Fillers & Discourse Markers','English',
'Filler words & discourse markers = từ đệm giúp câu nói TRÔI, câu giờ suy
nghĩ, và nối ý tự nhiên. Người bản xứ dùng liên tục.

FILLERS (câu giờ, đừng im bặt):
  well, um, uh, you know, I mean, like, so, actually, basically
  "Well, I think... you know... it depends."

DISCOURSE MARKERS (nối và điều hướng hội thoại):
  • Mở đầu:     "So,..."  "Well,..."  "Okay, so..."
  • Thêm ý:     "Also,", "Besides,", "On top of that,"
  • Đối lập:    "But,", "However,", "Actually,", "That said,"
  • Ví dụ:      "For example,", "Like,", "Say,"
  • Đổi chủ đề: "Anyway,", "By the way,", "Speaking of which,"
  • Kết luận:   "So yeah,", "In the end,", "All in all,"
  • Câu giờ:    "Let me think,", "How should I put it,"

MẸO: (1) filler giúp nghe TỰ NHIÊN và có thời gian nghĩ thay vì đứng hình;
(2) nhưng LẠM DỤNG "um, like, you know" nghe thiếu tự tin -> dùng vừa phải.
Thay khoảng lặng bằng "Well," hoặc "Let me think" nghe chủ động hơn là
"ummm". Đây là bí quyết nói trôi mà nhiều người học bỏ qua.',
'Filler words & discourse markers = small words that keep speech FLOWING,
buy thinking time, and connect ideas naturally. Natives use them constantly.

FILLERS (buy time, do not go silent):
  well, um, uh, you know, I mean, like, so, actually, basically
  "Well, I think... you know... it depends."

DISCOURSE MARKERS (connect and steer conversation):
  • Opening:      "So,..."  "Well,..."  "Okay, so..."
  • Adding:       "Also,", "Besides,", "On top of that,"
  • Contrasting:  "But,", "However,", "Actually,", "That said,"
  • Examples:     "For example,", "Like,", "Say,"
  • Topic shift:  "Anyway,", "By the way,", "Speaking of which,"
  • Concluding:   "So yeah,", "In the end,", "All in all,"
  • Buying time:  "Let me think,", "How should I put it,"

TIP: (1) fillers make speech NATURAL and give thinking time instead of
freezing; (2) but OVERUSING "um, like, you know" sounds unsure -> use them
in moderation. Replacing a pause with "Well," or "Let me think" sounds more
in-control than "ummm". This is a fluency trick many learners overlook.',
'[]',-500,-30)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ===== seed_english_native2 =====
-- ĐĂNG KÝ node: Native tips 2 (small talk, collocations, American vs British, register)
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('n_en_smalltalk','Small Talk & Giao tiếp','English',
'Small talk = trò chuyện xã giao ngắn (thời tiết, cuối tuần, công việc) để
tạo không khí. Người Mỹ small talk rất nhiều — biết vài mẫu là đủ tự tin.

CHÀO HỎI & ĐÁP:
  "How are you?" / "How''s it going?" / "How have you been?"
   -> "Good, thanks. You?" / "Pretty good." / "Not bad."
  (Lưu ý: "How are you?" thường là XÃ GIAO, không phải hỏi thật -> đáp ngắn)

MỞ CHỦ ĐỀ AN TOÀN:
  • Thời tiết: "Nice weather today, huh?"
  • Cuối tuần: "Any plans for the weekend?" / "How was your weekend?"
  • Công việc: "How''s work going?"
  • Khen:      "I like your jacket!"

CÂU HỮU ÍCH:
  • Chưa nghe rõ: "Sorry, could you say that again?" / "Come again?"
  • Câu giờ:      "That''s a good question..."
  • Kết thúc:     "Anyway, it was nice talking to you!" / "I''d better get
    going." / "Let''s catch up soon."

TRÁNH (chủ đề nhạy cảm với người lạ): tuổi, lương, cân nặng, tôn giáo,
chính trị.

MẸO: small talk KHÔNG cần sâu sắc — cần THÂN THIỆN và trôi. Thuộc vài mẫu
chào - đáp - mở topic - kết thúc là xử lý 90% tình huống. Mỉm cười + hỏi
lại ("You?") để giữ hội thoại tiếp diễn.',
'Small talk = brief social conversation (weather, weekend, work) to build
rapport. Americans do a lot of it - knowing a few templates is enough to be
confident.

GREETINGS & REPLIES:
  "How are you?" / "How''s it going?" / "How have you been?"
   -> "Good, thanks. You?" / "Pretty good." / "Not bad."
  (Note: "How are you?" is usually a PLEASANTRY, not a real question -> keep
   the reply short)

SAFE OPENERS:
  • Weather: "Nice weather today, huh?"
  • Weekend: "Any plans for the weekend?" / "How was your weekend?"
  • Work:    "How''s work going?"
  • Compliment: "I like your jacket!"

USEFUL LINES:
  • Did not catch it: "Sorry, could you say that again?" / "Come again?"
  • Buying time:      "That''s a good question..."
  • Ending:           "Anyway, it was nice talking to you!" / "I''d better
    get going." / "Let''s catch up soon."

AVOID (sensitive topics with strangers): age, salary, weight, religion,
politics.

TIP: small talk need NOT be deep - it needs to be FRIENDLY and flowing.
Memorize a few greet - reply - opener - closer templates to handle 90% of
situations. Smile and bounce it back ("You?") to keep it going.',
'[]',-560,-90),

('n_en_collocations','Collocations','English',
'Collocation = các từ hay ĐI CÙNG NHAU một cách tự nhiên. Dùng đúng nghe
bản xứ; ghép sai thì đúng ngữ pháp nhưng nghe lạ.

  ✓ make a decision   ✗ do a decision
  ✓ do homework       ✗ make homework
  ✓ heavy rain        ✗ strong rain
  ✓ fast food         ✗ quick food
  ✓ take a photo      ✗ make a photo

CẶP DO vs MAKE (hay nhầm):
  do:   homework, the dishes, research, business, a favor, exercise
  make: a decision, a mistake, money, progress, a plan, an effort, noise

ĐỘNG TỪ + DANH TỪ hay gặp:
  take: a break, a shower, a risk, notes, place
  have: breakfast, a good time, a look, a rest
  pay:  attention, a visit, a compliment
  heavy: heavy traffic, heavy rain;  strong: strong coffee, strong accent

MẸO: khi học từ mới, ghi luôn từ hay ĐI KÈM (vd "decision" -> "make a
decision"). Nghe/đọc nhiều rồi bắt chước NGUYÊN CỤM. Có thể tra từ điển
collocation. Đây là bước nâng từ "đúng ngữ pháp" lên "nghe tự nhiên như
bản xứ".',
'A collocation = words that naturally GO TOGETHER. Correct collocations
sound native; wrong pairings are grammatical but sound odd.

  ✓ make a decision   ✗ do a decision
  ✓ do homework       ✗ make homework
  ✓ heavy rain        ✗ strong rain
  ✓ fast food         ✗ quick food
  ✓ take a photo      ✗ make a photo

DO vs MAKE (often confused):
  do:   homework, the dishes, research, business, a favor, exercise
  make: a decision, a mistake, money, progress, a plan, an effort, noise

COMMON VERB + NOUN:
  take: a break, a shower, a risk, notes, place
  have: breakfast, a good time, a look, a rest
  pay:  attention, a visit, a compliment
  heavy: heavy traffic, heavy rain;  strong: strong coffee, strong accent

TIP: when learning a new word, record its usual PARTNERS (e.g. "decision"
-> "make a decision"). Listen/read a lot then imitate WHOLE chunks. Use a
collocation dictionary. This is the step from "grammatically correct" to
"sounds natural like a native".',
'[]',-500,-110),

('n_en_am_vs_br','Anh-Mỹ vs Anh-Anh','English',
'Anh-Mỹ (American) và Anh-Anh (British) khác nhau ở chính tả, từ vựng, phát
âm và đôi chỗ ngữ pháp. Nên chọn MỘT kiểu và nhất quán (ở đây: Mỹ).

CHÍNH TẢ:
  Mỹ           Anh
  color        colour      (-or vs -our: favor, honor, labor)
  center       centre      (-er vs -re: theater, meter)
  organize     organise    (-ize vs -ise: realize, analyze)
  traveling    travelling  (Mỹ không gấp đôi l khi nhấn âm đầu)
  defense      defence;    catalog / catalogue

TỪ VỰNG:
  Mỹ           Anh
  apartment    flat        truck / lorry      elevator / lift
  cookie       biscuit     fall / autumn      gas / petrol
  vacation     holiday     pants / trousers   soccer / football
  sidewalk     pavement    candy / sweets     subway / underground

PHÁT ÂM: giọng Mỹ rhotic (đọc /r/ cuối); flap T (water -> "wader");
"schedule" Mỹ /ˈskedʒuːl/ vs Anh /ˈʃedjuːl/.

NGỮ PHÁP nhỏ: Mỹ "on the weekend" (Anh "at the weekend"); Mỹ hay dùng past
simple với already/just ("I already ate"), Anh thiên present perfect ("I''ve
already eaten"); "gotten" (Mỹ) vs "got" (Anh).

MẸO: NHẤT QUÁN một kiểu (đừng lẫn color + centre). Đặt spell-check sang
"English (US)".',
'American and British English differ in spelling, vocabulary, pronunciation,
and some grammar. Pick ONE and stay consistent (here: American).

SPELLING:
  US           UK
  color        colour      (-or vs -our: favor, honor, labor)
  center       centre      (-er vs -re: theater, meter)
  organize     organise    (-ize vs -ise: realize, analyze)
  traveling    travelling  (US does not double l when stress is on the 1st)
  defense      defence;    catalog / catalogue

VOCABULARY:
  US           UK
  apartment    flat        truck / lorry      elevator / lift
  cookie       biscuit     fall / autumn      gas / petrol
  vacation     holiday     pants / trousers   soccer / football
  sidewalk     pavement    candy / sweets     subway / underground

PRONUNCIATION: American is rhotic (final /r/ pronounced); flap T (water ->
"wader"); "schedule" US /ˈskedʒuːl/ vs UK /ˈʃedjuːl/.

MINOR GRAMMAR: US "on the weekend" (UK "at the weekend"); US often uses past
simple with already/just ("I already ate"), UK leans on present perfect
("I''ve already eaten"); "gotten" (US) vs "got" (UK).

TIP: stay CONSISTENT in one variety (do not mix color + centre). Set your
spell-check to "English (US)".',
'[]',-440,-90),

('n_en_politeness','Lịch sự & Mức trang trọng','English',
'Register = mức độ trang trọng của ngôn ngữ. Cùng một ý có nhiều cách nói
tùy đối tượng (bạn bè / đồng nghiệp / khách hàng / sếp). Chọn sai nghe thô
hoặc khách sáo quá.

THANG TRANG TRỌNG (cùng ý "muốn một ly cà phê"):
  Suồng sã:   "Gimme a coffee." / "I want a coffee."
  Trung tính: "Can I get a coffee?"
  Lịch sự:    "Could I please get a coffee?"
  Rất trang trọng: "I was wondering if I could get a coffee." /
                   "Would it be possible to...?"

NGUYÊN TẮC LỊCH SỰ (rất quan trọng với người Việt):
  • Dùng CÂU HỎI + modal thay mệnh lệnh: "Could you...?" thay "Do this."
  • Thêm "please", "would you mind...", "sorry to bother you,..."
  • Softeners: "just", "a bit", "maybe", "I think", "kind of"
    -> "Could you just wait a bit?" mềm hơn "Wait."
  • Từ chối gián tiếp: "That sounds great, but..." / "I''m not sure..."

VĂN NÓI vs VIẾT: email công việc trang trọng hơn chat; tránh gonna/wanna,
slang trong email chính thức.

MẸO người Việt: tiếng Anh nhờ vả/yêu cầu thường GIÁN TIẾP hơn tiếng Việt.
Mệnh lệnh trực tiếp ("Send me the file.") dễ bị coi là cộc lốc; "Could you
send me the file, please?" an toàn hơn trong công việc.',
'Register = the level of formality of language. The same idea has many
phrasings depending on the audience (friends / colleagues / clients /
boss). The wrong choice sounds rude or overly stiff.

FORMALITY LADDER (same idea "I want a coffee"):
  Casual:   "Gimme a coffee." / "I want a coffee."
  Neutral:  "Can I get a coffee?"
  Polite:   "Could I please get a coffee?"
  Very formal: "I was wondering if I could get a coffee." /
               "Would it be possible to...?"

POLITENESS PRINCIPLES (very important for Vietnamese speakers):
  • Use a QUESTION + modal instead of a command: "Could you...?" not "Do this."
  • Add "please", "would you mind...", "sorry to bother you,..."
  • Softeners: "just", "a bit", "maybe", "I think", "kind of"
    -> "Could you just wait a bit?" is softer than "Wait."
  • Decline indirectly: "That sounds great, but..." / "I''m not sure..."

SPEECH vs WRITING: work emails are more formal than chat; avoid
gonna/wanna and slang in official emails.

TIP for Vietnamese: English requests are usually more INDIRECT than in
Vietnamese. A direct command ("Send me the file.") can seem curt; "Could
you send me the file, please?" is safer at work.',
'[]',-380,-110)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ===== seed_english_edges =====
-- ĐĂNG KÝ edges cho topic Tiếng Anh Mỹ (part-of + vài related)
INSERT INTO kg_edges (id,source,target,type) VALUES
-- root -> topic
('e_root_t_en','root','t_en','part-of'),
-- topic -> sections
('e_t_en_s_en_pron','t_en','s_en_pron','part-of'),
('e_t_en_s_en_chunk','t_en','s_en_chunk','part-of'),
('e_t_en_s_en_grammar','t_en','s_en_grammar','part-of'),
('e_t_en_s_en_tenses','t_en','s_en_tenses','part-of'),
('e_t_en_s_en_verbs','t_en','s_en_verbs','part-of'),
('e_t_en_s_en_native','t_en','s_en_native','part-of'),
-- section Phát âm -> leaf
('e_s_en_pron_ipa','s_en_pron','n_en_ipa','part-of'),
('e_s_en_pron_r','s_en_pron','n_en_r','part-of'),
('e_s_en_pron_t','s_en_pron','n_en_t','part-of'),
('e_s_en_pron_schwa','s_en_pron','n_en_schwa','part-of'),
('e_s_en_pron_wordstress','s_en_pron','n_en_wordstress','part-of'),
('e_s_en_pron_sentencestress','s_en_pron','n_en_sentencestress','part-of'),
('e_s_en_pron_intonation','s_en_pron','n_en_intonation','part-of'),
('e_s_en_pron_linking','s_en_pron','n_en_linking','part-of'),
('e_s_en_pron_th','s_en_pron','n_en_th','part-of'),
-- section Chunking -> leaf
('e_s_en_chunk_chunking','s_en_chunk','n_en_chunking','part-of'),
('e_s_en_chunk_connected','s_en_chunk','n_en_connected','part-of'),
('e_s_en_chunk_rhythm','s_en_chunk','n_en_rhythm','part-of'),
-- section Grammar -> leaf
('e_s_en_grammar_wordorder','s_en_grammar','n_en_wordorder','part-of'),
('e_s_en_grammar_articles','s_en_grammar','n_en_articles','part-of'),
('e_s_en_grammar_nouns','s_en_grammar','n_en_nouns','part-of'),
('e_s_en_grammar_pronouns','s_en_grammar','n_en_pronouns','part-of'),
('e_s_en_grammar_adj_adv','s_en_grammar','n_en_adj_adv','part-of'),
('e_s_en_grammar_prepositions','s_en_grammar','n_en_prepositions','part-of'),
('e_s_en_grammar_modals','s_en_grammar','n_en_modals','part-of'),
('e_s_en_grammar_conditionals','s_en_grammar','n_en_conditionals','part-of'),
('e_s_en_grammar_passive','s_en_grammar','n_en_passive','part-of'),
('e_s_en_grammar_reported','s_en_grammar','n_en_reported','part-of'),
('e_s_en_grammar_questions','s_en_grammar','n_en_questions','part-of'),
('e_s_en_grammar_gerund_inf','s_en_grammar','n_en_gerund_inf','part-of'),
-- section Tenses -> leaf
('e_s_en_tenses_map','s_en_tenses','n_en_tenses_map','part-of'),
('e_s_en_tenses_present','s_en_tenses','n_en_present','part-of'),
('e_s_en_tenses_past','s_en_tenses','n_en_past','part-of'),
('e_s_en_tenses_future','s_en_tenses','n_en_future','part-of'),
-- section Verbs -> leaf
('e_s_en_verbs_s_es','s_en_verbs','n_en_s_es','part-of'),
('e_s_en_verbs_ed','s_en_verbs','n_en_ed','part-of'),
('e_s_en_verbs_ing','s_en_verbs','n_en_ing','part-of'),
('e_s_en_verbs_irregular','s_en_verbs','n_en_irregular','part-of'),
('e_s_en_verbs_plural_irregular','s_en_verbs','n_en_plural_irregular','part-of'),
-- section Native -> leaf
('e_s_en_native_contractions','s_en_native','n_en_contractions','part-of'),
('e_s_en_native_phrasal','s_en_native','n_en_phrasal','part-of'),
('e_s_en_native_idioms','s_en_native','n_en_idioms','part-of'),
('e_s_en_native_slang','s_en_native','n_en_slang','part-of'),
('e_s_en_native_fillers','s_en_native','n_en_fillers','part-of'),
('e_s_en_native_smalltalk','s_en_native','n_en_smalltalk','part-of'),
('e_s_en_native_collocations','s_en_native','n_en_collocations','part-of'),
('e_s_en_native_am_vs_br','s_en_native','n_en_am_vs_br','part-of'),
('e_s_en_native_politeness','s_en_native','n_en_politeness','part-of'),
-- related (liên kết chéo ý nghĩa)
('e_en_schwa_wordstress','n_en_schwa','n_en_wordstress','related'),
('e_en_wordstress_sentencestress','n_en_wordstress','n_en_sentencestress','related'),
('e_en_sentencestress_rhythm','n_en_sentencestress','n_en_rhythm','related'),
('e_en_linking_connected','n_en_linking','n_en_connected','related'),
('e_en_connected_contractions','n_en_connected','n_en_contractions','related'),
('e_en_s_es_nouns','n_en_s_es','n_en_nouns','related'),
('e_en_ed_irregular','n_en_ed','n_en_irregular','related'),
('e_en_ing_gerund_inf','n_en_ing','n_en_gerund_inf','related'),
('e_en_present_s_es','n_en_present','n_en_s_es','related'),
('e_en_tenses_irregular','n_en_tenses_map','n_en_irregular','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);

-- ===== seed_php_1 =====
-- ===================================================================
--  TOPIC: PHP (song ngữ VI + EN, ví dụ code). File 1: cấu trúc + Cơ bản + OOP
--  Áp: docker compose exec -T mysql \
--        mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 \
--        "$DB_NAME" < seed_php_1.sql
-- ===================================================================
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_php','PHP','Backend',
'Ngôn ngữ kịch bản phía server phổ biến cho web: cú pháp & kiểu dữ liệu,
mảng, hàm, lập trình hướng đối tượng, Composer/PSR, vòng đời request,
PDO và bảo mật, cùng PHP hiện đại (8.x) và framework.',
'A popular server-side scripting language for the web: syntax & types,
arrays, functions, object-oriented programming, Composer/PSR, the request
lifecycle, PDO and security, plus modern PHP (8.x) and frameworks.',
'[]',600,-380),

('s_php_basics','PHP Cơ bản','Backend',
'Cú pháp, biến & kiểu dữ liệu, mảng, hàm và chuỗi — nền tảng của PHP.',
'Syntax, variables & types, arrays, functions, and strings - the PHP core.',
'[]',520,-460),
('s_php_oop','Lập trình hướng đối tượng','Backend',
'Class/object, interface/abstract, trait, namespace & autoload bằng Composer.',
'Classes/objects, interfaces/abstract, traits, namespaces & Composer autoloading.',
'[]',660,-460),
('s_php_web','PHP cho Web','Backend',
'Vòng đời request, superglobals & form, session/cookie, PDO truy vấn DB, và
các lỗ hổng bảo mật (SQLi/XSS/CSRF).',
'The request lifecycle, superglobals & forms, sessions/cookies, PDO database
access, and security holes (SQLi/XSS/CSRF).',
'[]',520,-300),
('s_php_modern','PHP hiện đại','Backend',
'Tính năng PHP 8.x, chuẩn PSR + Composer, framework (Laravel/Symfony) và
PHP-FPM/OPcache.',
'PHP 8.x features, PSR standards + Composer, frameworks (Laravel/Symfony),
and PHP-FPM/OPcache.',
'[]',680,-300),

-- ------------------------- CƠ BẢN ---------------------------------
('n_php_syntax','Cú pháp & nền tảng','Backend',
'PHP là ngôn ngữ kịch bản phía SERVER, có thể nhúng trong HTML, chạy bởi
trình thông dịch. File .php; mã PHP nằm trong <?php ... ?>.

  <?php
    echo "Hello";        // in ra màn hình
    $name = "An";        // biến LUÔN bắt đầu bằng $
    echo "Hi $name";     // nội suy biến trong nháy KÉP -> Hi An
    echo ''Hi $name'';   // nháy ĐƠN: KHÔNG nội suy -> Hi $name
  ?>

ĐẶC ĐIỂM:
  • Biến bắt đầu bằng $, không khai báo kiểu (dynamically typed).
  • Kết thúc câu lệnh bằng dấu ;
  • Comment: // hoặc # (1 dòng), /* ... */ (nhiều dòng).
  • Nối chuỗi bằng dấu chấm: "a" . "b" -> "ab"
  • So sánh: == (lỏng, có ép kiểu) vs === (chặt, cùng kiểu + giá trị).

  var_dump(0 == "a");   // PHP 8: false (trước 8 là true - bẫy kinh điển)
  var_dump("0" == false); // true (lỏng)   "0" === false // false (chặt)

CHẠY: qua web server (Nginx/Apache + PHP-FPM) hoặc CLI: php file.php

MẸO: luôn ưu tiên === để tránh bug ép kiểu ngầm. PHP 8 đã siết lại quy
tắc so sánh số với chuỗi nên an toàn hơn trước.',
'PHP is a SERVER-side scripting language, embeddable in HTML, run by an
interpreter. Files end in .php; PHP code lives inside <?php ... ?>.

  <?php
    echo "Hello";        // print to output
    $name = "An";        // variables ALWAYS start with $
    echo "Hi $name";     // interpolation in DOUBLE quotes -> Hi An
    echo ''Hi $name'';   // SINGLE quotes: NO interpolation -> Hi $name
  ?>

CHARACTERISTICS:
  • Variables start with $, no type declaration (dynamically typed).
  • Statements end with ;
  • Comments: // or # (one line), /* ... */ (multi-line).
  • String concatenation uses a dot: "a" . "b" -> "ab"
  • Comparison: == (loose, with type juggling) vs === (strict, same type + value).

  var_dump(0 == "a");     // PHP 8: false (before 8 it was true - a classic trap)
  var_dump("0" == false); // true (loose)   "0" === false // false (strict)

RUN: via a web server (Nginx/Apache + PHP-FPM) or the CLI: php file.php

TIP: always prefer === to avoid implicit type-juggling bugs. PHP 8 tightened
number-vs-string comparison rules, so it is safer than before.',
'[]',440,-520),

('n_php_types','Biến & Kiểu dữ liệu','Backend',
'PHP có kiểu động: biến mang kiểu theo GIÁ TRỊ gán vào, có thể đổi kiểu.

KIỂU VÔ HƯỚNG: int, float, string, bool.
KIỂU HỢP: array, object, callable, iterable.
ĐẶC BIỆT: null (không giá trị), resource.

  $n = 42;            // int
  $pi = 3.14;         // float
  $s = "hello";       // string
  $ok = true;         // bool
  $x = null;          // null

  gettype($n);              // "integer"
  var_dump(is_int($n));     // bool(true)
  $n = (string)$n;          // ép kiểu tường minh -> "42"

KHAI BÁO KIỂU (type declaration, khuyên dùng từ PHP 7+):
  function add(int $a, int $b): int { return $a + $b; }
  declare(strict_types=1);  // đặt ĐẦU file -> ép kiểu chặt, báo lỗi nếu sai

HẰNG: const MAX = 100;  hoặc  define("MAX", 100);

GIÁ TRỊ "falsy" (coi như false): 0, 0.0, "", "0", [], null, false.

MẸO: bật declare(strict_types=1) + khai báo kiểu tham số/trả về -> bắt lỗi
sớm, code rõ ràng, IDE gợi ý tốt. Đây là thực hành chuẩn của PHP hiện đại.',
'PHP is dynamically typed: a variable takes the type of the VALUE assigned,
and can change type.

SCALAR TYPES: int, float, string, bool.
COMPOUND TYPES: array, object, callable, iterable.
SPECIAL: null (no value), resource.

  $n = 42;            // int
  $pi = 3.14;         // float
  $s = "hello";       // string
  $ok = true;         // bool
  $x = null;          // null

  gettype($n);              // "integer"
  var_dump(is_int($n));     // bool(true)
  $n = (string)$n;          // explicit cast -> "42"

TYPE DECLARATIONS (recommended since PHP 7+):
  function add(int $a, int $b): int { return $a + $b; }
  declare(strict_types=1);  // put at the FILE TOP -> strict typing, errors on mismatch

CONSTANTS: const MAX = 100;  or  define("MAX", 100);

"FALSY" VALUES (treated as false): 0, 0.0, "", "0", [], null, false.

TIP: enable declare(strict_types=1) + declare parameter/return types -> catch
bugs early, clearer code, better IDE hints. This is standard modern PHP practice.',
'[]',420,-460),

('n_php_arrays','Mảng (Arrays)','Backend',
'Mảng PHP cực kỳ linh hoạt: vừa là danh sách theo chỉ số, vừa là bản đồ
khóa-giá trị (associative array). Một cấu trúc dùng cho mọi thứ.

  $list = [1, 2, 3];                  // mảng chỉ số (0,1,2)
  $map  = ["name" => "An", "age" => 30]; // mảng kết hợp (khóa => giá trị)
  $list[] = 4;                        // thêm vào cuối
  echo $map["name"];                  // "An"

DUYỆT:
  foreach ($list as $v) { echo $v; }
  foreach ($map as $key => $val) { echo "$key=$val"; }

HÀM MẢNG HAY DÙNG:
  count($a)          // số phần tử
  array_map(fn($x)=>$x*2, $list)      // biến đổi từng phần tử
  array_filter($list, fn($x)=>$x>1)   // lọc
  array_reduce($list, fn($c,$x)=>$c+$x, 0) // gộp
  in_array(2,$list), array_keys($map), array_values($map)
  array_merge($a,$b), sort($a), usort($a, $cmp)

SPREAD & DESTRUCTURING:
  $all = [...$a, ...$b];              // gộp
  ["name"=>$name] = $map;             // rút khóa ra biến

MẸO: mảng kết hợp là "trái tim" của PHP (config, dữ liệu form, kết quả DB
đều là mảng). Nắm array_map/filter/reduce giúp code hàm gọn, tránh vòng
lặp thủ công.',
'PHP arrays are extremely flexible: both an indexed list and a key-value map
(associative array). One structure used for everything.

  $list = [1, 2, 3];                  // indexed array (0,1,2)
  $map  = ["name" => "An", "age" => 30]; // associative array (key => value)
  $list[] = 4;                        // append to the end
  echo $map["name"];                  // "An"

ITERATION:
  foreach ($list as $v) { echo $v; }
  foreach ($map as $key => $val) { echo "$key=$val"; }

COMMON ARRAY FUNCTIONS:
  count($a)          // number of elements
  array_map(fn($x)=>$x*2, $list)      // transform each element
  array_filter($list, fn($x)=>$x>1)   // filter
  array_reduce($list, fn($c,$x)=>$c+$x, 0) // fold
  in_array(2,$list), array_keys($map), array_values($map)
  array_merge($a,$b), sort($a), usort($a, $cmp)

SPREAD & DESTRUCTURING:
  $all = [...$a, ...$b];              // merge
  ["name"=>$name] = $map;             // pull a key into a variable

TIP: the associative array is the heart of PHP (config, form data, DB rows
are all arrays). Mastering array_map/filter/reduce yields concise functional
code and avoids manual loops.',
'[]',480,-440),

('n_php_functions','Hàm (Functions)','Backend',
'Hàm gom logic tái dùng. PHP hỗ trợ tham số mặc định, kiểu, biến động và
closure (hàm nặc danh).

  function greet(string $name, string $greeting = "Hi"): string {
    return "$greeting, $name!";
  }
  echo greet("An");            // "Hi, An!"  (dùng mặc định)
  echo greet("An", "Hello");   // "Hello, An!"

CLOSURE / ARROW FUNCTION:
  $double = function($x) { return $x * 2; };
  $triple = fn($x) => $x * 3;         // arrow fn (PHP 7.4+), tự bắt biến ngoài

  $factor = 10;
  $scale = fn($x) => $x * $factor;    // arrow fn TỰ nhìn thấy $factor
  $scale2 = function($x) use ($factor) { return $x * $factor; }; // phải use

THAM SỐ NÂNG CAO:
  function sum(...$nums) { return array_sum($nums); }  // variadic
  sum(1, 2, 3);                       // 6
  named args (PHP 8): greet(name: "An", greeting: "Yo");

MẸO: dùng khai báo kiểu tham số + trả về để rõ ràng và an toàn. Arrow fn
(fn) gọn cho callback (array_map/filter); function...use khi cần logic dài
hoặc sửa biến ngoài.',
'Functions group reusable logic. PHP supports default parameters, types,
variadics, and closures (anonymous functions).

  function greet(string $name, string $greeting = "Hi"): string {
    return "$greeting, $name!";
  }
  echo greet("An");            // "Hi, An!"  (uses the default)
  echo greet("An", "Hello");   // "Hello, An!"

CLOSURE / ARROW FUNCTION:
  $double = function($x) { return $x * 2; };
  $triple = fn($x) => $x * 3;         // arrow fn (PHP 7.4+), auto-captures outer vars

  $factor = 10;
  $scale = fn($x) => $x * $factor;    // arrow fn SEES $factor automatically
  $scale2 = function($x) use ($factor) { return $x * $factor; }; // needs use

ADVANCED PARAMETERS:
  function sum(...$nums) { return array_sum($nums); }  // variadic
  sum(1, 2, 3);                       // 6
  named args (PHP 8): greet(name: "An", greeting: "Yo");

TIP: declare parameter + return types for clarity and safety. Arrow fns (fn)
are concise for callbacks (array_map/filter); use function...use when you
need longer logic or to modify outer variables.',
'[]',540,-420),

-- ------------------------- OOP ------------------------------------
('n_php_oop','Class, Object & Kế thừa','Backend',
'PHP hỗ trợ OOP đầy đủ: class, đối tượng, kế thừa, đóng gói (visibility),
abstract class.

  class Animal {
    public function __construct(
      protected string $name          // PHP 8: khai báo + gán thẳng
    ) {}
    public function speak(): string { return "..."; }
  }
  class Dog extends Animal {
    public function speak(): string { return "$this->name says Woof"; }
  }
  $d = new Dog("Rex");
  echo $d->speak();                   // "Rex says Woof"

VISIBILITY (đóng gói):
  public    : truy cập mọi nơi
  protected : trong class này + class con
  private   : chỉ trong chính class này

THÀNH PHẦN:
  • $this  -> đối tượng hiện tại;  self:: / static:: -> chính class
  • static : thuộc CLASS, không thuộc instance (Counter::$count)
  • const  : hằng của class (self::MAX)
  • abstract class: không tạo instance được, để làm khuôn kế thừa.
  • __construct/__destruct, __get/__set (magic methods).

MẸO: PHP 8 "constructor property promotion" (khai kiểu + visibility ngay ở
tham số __construct) giúp bỏ bớt boilerplate. Dùng type + visibility rõ
ràng; ưu tiên composition hơn kế thừa sâu.',
'PHP has full OOP: classes, objects, inheritance, encapsulation (visibility),
abstract classes.

  class Animal {
    public function __construct(
      protected string $name          // PHP 8: declare + assign inline
    ) {}
    public function speak(): string { return "..."; }
  }
  class Dog extends Animal {
    public function speak(): string { return "$this->name says Woof"; }
  }
  $d = new Dog("Rex");
  echo $d->speak();                   // "Rex says Woof"

VISIBILITY (encapsulation):
  public    : accessible everywhere
  protected : this class + subclasses
  private   : only within this class

MEMBERS:
  • $this  -> the current object;  self:: / static:: -> the class itself
  • static : belongs to the CLASS, not an instance (Counter::$count)
  • const  : a class constant (self::MAX)
  • abstract class: cannot be instantiated, serves as an inheritance template.
  • __construct/__destruct, __get/__set (magic methods).

TIP: PHP 8 "constructor property promotion" (declaring type + visibility
right in the __construct parameters) removes boilerplate. Use clear types +
visibility; prefer composition over deep inheritance.',
'[]',640,-540),

('n_php_traits','Interface, Abstract & Trait','Backend',
'Ba công cụ tổ chức OOP trong PHP:

INTERFACE — hợp đồng (chỉ chữ ký, không thân hàm); một class có thể
implements NHIỀU interface:
  interface Jsonable { public function toJson(): string; }
  class User implements Jsonable {
    public function toJson(): string { return json_encode($this); }
  }

ABSTRACT CLASS — khuôn có sẵn một phần cài đặt, KHÔNG tạo instance được;
class con phải hiện thực các method abstract:
  abstract class Shape {
    abstract public function area(): float;   // con phải viết
    public function describe(): string { return "Area = " . $this->area(); }
  }

TRAIT — tái dùng CODE ngang giữa nhiều class (PHP đơn kế thừa nên trait
giải bài "muốn dùng chung method mà không kế thừa"):
  trait Timestamps {
    public function touch(): void { $this->updatedAt = time(); }
  }
  class Post { use Timestamps; }
  class Comment { use Timestamps; }   // cả hai dùng chung touch()

KHÁC NHAU:
  • interface: "CÓ THỂ làm gì" (hợp đồng, đa hình) — không code.
  • abstract : quan hệ "là một" + chia sẻ một phần code.
  • trait    : nhồi code dùng chung vào nhiều class không liên quan.

MẸO: lập trình HƯỚNG interface (type-hint theo interface) để dễ thay/mock.
Trait tiện nhưng lạm dụng gây khó lần nguồn method — dùng có chừng mực.',
'Three OOP organization tools in PHP:

INTERFACE - a contract (signatures only, no bodies); a class can implement
MANY interfaces:
  interface Jsonable { public function toJson(): string; }
  class User implements Jsonable {
    public function toJson(): string { return json_encode($this); }
  }

ABSTRACT CLASS - a partially-implemented template that CANNOT be
instantiated; subclasses must implement the abstract methods:
  abstract class Shape {
    abstract public function area(): float;   // subclass must write it
    public function describe(): string { return "Area = " . $this->area(); }
  }

TRAIT - horizontal CODE reuse across classes (PHP has single inheritance, so
traits solve "share methods without inheriting"):
  trait Timestamps {
    public function touch(): void { $this->updatedAt = time(); }
  }
  class Post { use Timestamps; }
  class Comment { use Timestamps; }   // both share touch()

DIFFERENCES:
  • interface: "CAN do what" (contract, polymorphism) - no code.
  • abstract : an "is-a" relation + some shared code.
  • trait    : inject shared code into unrelated classes.

TIP: program to INTERFACES (type-hint by interface) for easy swapping/mocking.
Traits are handy but overuse makes methods hard to trace - use in moderation.',
'[]',720,-500),

('n_php_namespaces','Namespace, Autoload & Composer','Backend',
'Namespace tránh trùng tên class giữa các thư viện; Composer là trình quản
lý gói + tự nạp file (autoload) theo chuẩn PSR-4.

NAMESPACE:
  namespace App\\Service;          // khai báo ở đầu file
  class Mailer { }

  // file khác:
  use App\\Service\\Mailer;        // import
  $m = new Mailer();

COMPOSER — quản lý phụ thuộc:
  composer require guzzlehttp/guzzle    // cài gói + ghi vào composer.json
  composer install                      // cài theo composer.lock
  composer update                       // nâng cấp

AUTOLOAD PSR-4 (composer.json): ánh xạ namespace -> thư mục:
  "autoload": { "psr-4": { "App\\\\": "src/" } }
  -> class App\\Service\\Mailer nằm ở file src/Service/Mailer.php
  Nạp một dòng duy nhất: require "vendor/autoload.php";

  -> KHÔNG cần require từng file class; Composer tự tìm theo tên class.

MẸO: cấu trúc dự án PHP hiện đại = 1 namespace gốc (App\\) map vào src/,
mọi phụ thuộc qua Composer. composer.lock phải commit để cài đúng phiên
bản trên mọi máy/server (giống package-lock.json của Node).',
'Namespaces avoid class-name clashes between libraries; Composer is the
dependency manager + file autoloader following the PSR-4 standard.

NAMESPACE:
  namespace App\\Service;          // declared at the file top
  class Mailer { }

  // another file:
  use App\\Service\\Mailer;        // import
  $m = new Mailer();

COMPOSER - dependency management:
  composer require guzzlehttp/guzzle    // install a package + record in composer.json
  composer install                      // install per composer.lock
  composer update                       // upgrade

PSR-4 AUTOLOAD (composer.json): maps a namespace -> a directory:
  "autoload": { "psr-4": { "App\\\\": "src/" } }
  -> class App\\Service\\Mailer lives in src/Service/Mailer.php
  Load with a single line: require "vendor/autoload.php";

  -> NO need to require each class file; Composer finds them by class name.

TIP: a modern PHP project layout = one root namespace (App\\) mapped to src/,
all dependencies via Composer. Commit composer.lock so every machine/server
installs the exact versions (like Node package-lock.json).',
'[]',740,-440)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ===== seed_php_2 =====
-- TOPIC PHP file 2: Web + Modern
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('n_php_request','Vòng đời request','Backend',
'Khác Node (server thường trực), PHP truyền thống theo mô hình
SHARED-NOTHING: MỖI request khởi tạo lại toàn bộ, chạy xong thì XÓA sạch
-> không giữ state trong bộ nhớ giữa các request.

SƠ ĐỒ (PHP-FPM):
  Client -> Nginx -> PHP-FPM -> khởi tạo PHP -> chạy script -> trả HTML -> dọn sạch
                                (mỗi request = một môi trường mới, sạch)

Ý NGHĨA:
  • Biến toàn cục KHÔNG sống qua request -> muốn giữ state phải dùng
    session / DB / cache (Redis).
  • Ít lo memory leak tích lũy như server thường trực (xong là giải phóng).
  • Đánh đổi: chi phí khởi tạo MỖI request -> giảm bằng OPcache (cache bytecode).

KHÁC NODE.JS: Node một tiến trình phục vụ nhiều request, giữ state trong RAM
(phải cẩn thận leak); PHP mỗi request sạch — đơn giản, nhưng cần OPcache +
FPM để nhanh.

MẸO: hiểu shared-nothing giải thích vì sao PHP dùng $_SESSION/DB cho state,
và vì sao PHP dễ SCALE NGANG (không có state trong tiến trình -> thêm máy
thoải mái).',
'Unlike Node (a long-running server), traditional PHP uses a SHARED-NOTHING
model: EACH request re-initializes everything and wipes it all when done
-> no in-memory state is kept between requests.

DIAGRAM (PHP-FPM):
  Client -> Nginx -> PHP-FPM -> init PHP -> run script -> return HTML -> clean up
                                (each request = a fresh, clean environment)

IMPLICATIONS:
  • Global variables do NOT survive across requests -> to keep state use
    sessions / DB / cache (Redis).
  • Less worry about accumulating memory leaks than a long-running server
    (everything is freed at the end).
  • Trade-off: an init cost PER request -> reduced by OPcache (bytecode cache).

VS NODE.JS: Node has one process serving many requests, holding state in RAM
(watch for leaks); PHP starts each request clean - simpler, but needs OPcache
+ FPM to be fast.

TIP: understanding shared-nothing explains why PHP uses $_SESSION/DB for
state, and why PHP scales HORIZONTALLY easily (no in-process state -> add
machines freely).',
'[]',440,-340),

('n_php_superglobals','Superglobals & Form','Backend',
'Superglobals là các mảng toàn cục PHP tự tạo, truy cập được ở MỌI nơi,
chứa dữ liệu của request.

  $_GET     - tham số query string (?q=abc)
  $_POST    - dữ liệu form gửi bằng POST
  $_REQUEST - gộp GET+POST+COOKIE (nên TRÁNH, mơ hồ nguồn)
  $_SERVER  - thông tin server/request ($_SERVER["REQUEST_METHOD"])
  $_FILES   - file upload
  $_SESSION - dữ liệu phiên;   $_COOKIE - cookie
  $_ENV / getenv() - biến môi trường

XỬ LÝ FORM:
  if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $email = trim($_POST["email"] ?? "");     // ?? tránh lỗi undefined
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
      // báo lỗi
    }
  }

QUAN TRỌNG (bảo mật): dữ liệu từ $_GET/$_POST/$_FILES là INPUT NGƯỜI DÙNG
-> KHÔNG tin. Luôn validate + escape trước khi dùng; đừng nhét thẳng vào
SQL hay HTML.

MẸO: dùng ?? (null coalescing) để đọc key có thể thiếu; validate bằng
filter_var; ép kiểu ((int)$_GET["id"]) khi mong đợi số. Với API hiện đại,
dữ liệu JSON đọc qua json_decode(file_get_contents("php://input")).',
'Superglobals are global arrays PHP creates automatically, accessible
EVERYWHERE, holding the request data.

  $_GET     - query-string params (?q=abc)
  $_POST    - form data sent via POST
  $_REQUEST - GET+POST+COOKIE combined (AVOID, ambiguous source)
  $_SERVER  - server/request info ($_SERVER["REQUEST_METHOD"])
  $_FILES   - uploaded files
  $_SESSION - session data;   $_COOKIE - cookies
  $_ENV / getenv() - environment variables

HANDLING A FORM:
  if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $email = trim($_POST["email"] ?? "");     // ?? avoids undefined errors
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
      // report an error
    }
  }

IMPORTANT (security): data from $_GET/$_POST/$_FILES is USER INPUT -> do NOT
trust it. Always validate + escape before use; never drop it straight into
SQL or HTML.

TIP: use ?? (null coalescing) to read possibly-missing keys; validate with
filter_var; cast ((int)$_GET["id"]) when you expect a number. For modern
APIs, read JSON via json_decode(file_get_contents("php://input")).',
'[]',420,-280),

('n_php_pdo','PDO & Database','Backend',
'PDO (PHP Data Objects) là lớp truy cập DB thống nhất (MySQL, PostgreSQL...),
hỗ trợ PREPARED STATEMENTS chống SQL injection.

KẾT NỐI:
  $pdo = new PDO("mysql:host=localhost;dbname=app;charset=utf8mb4", $u, $p, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,       // lỗi -> ném exception
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,  // fetch ra mảng kết hợp
  ]);

TRUY VẤN có tham số (BẮT BUỘC khi có input người dùng):
  $stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
  $stmt->execute([$email]);          // tham số TÁCH khỏi câu SQL
  $user = $stmt->fetch();            // 1 dòng
  $all  = $stmt->fetchAll();         // tất cả
  // named placeholder:
  $pdo->prepare("... WHERE id = :id")->execute([":id" => $id]);

GHI + transaction:
  $stmt = $pdo->prepare("INSERT INTO users(name,email) VALUES(?,?)");
  $stmt->execute([$name, $email]);
  $id = $pdo->lastInsertId();

  $pdo->beginTransaction();
  try { /* nhiều lệnh */ $pdo->commit(); }
  catch (Exception $e) { $pdo->rollBack(); throw $e; }

MẸO: LUÔN dùng prepared statement, ĐỪNG nối chuỗi input vào SQL. Đặt
ERRMODE_EXCEPTION để lỗi không bị nuốt. PDO là nền tảng bên dưới mọi ORM
(Eloquent của Laravel, Doctrine của Symfony).',
'PDO (PHP Data Objects) is a unified DB access layer (MySQL, PostgreSQL...)
with PREPARED STATEMENTS to prevent SQL injection.

CONNECT:
  $pdo = new PDO("mysql:host=localhost;dbname=app;charset=utf8mb4", $u, $p, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,       // errors -> throw exceptions
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,  // fetch as associative arrays
  ]);

PARAMETERIZED QUERY (MANDATORY with user input):
  $stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
  $stmt->execute([$email]);          // params SEPARATED from the SQL
  $user = $stmt->fetch();            // one row
  $all  = $stmt->fetchAll();         // all rows
  // named placeholder:
  $pdo->prepare("... WHERE id = :id")->execute([":id" => $id]);

WRITE + transaction:
  $stmt = $pdo->prepare("INSERT INTO users(name,email) VALUES(?,?)");
  $stmt->execute([$name, $email]);
  $id = $pdo->lastInsertId();

  $pdo->beginTransaction();
  try { /* several statements */ $pdo->commit(); }
  catch (Exception $e) { $pdo->rollBack(); throw $e; }

TIP: ALWAYS use prepared statements, NEVER concatenate input into SQL. Set
ERRMODE_EXCEPTION so errors are not swallowed. PDO underlies every ORM
(Laravel Eloquent, Symfony Doctrine).',
'[]',480,-260),

('n_php_security','Bảo mật Web (SQLi/XSS/CSRF)','Backend',
'Các lỗ hổng web phổ biến và cách chặn trong PHP:

SQL INJECTION — nối input vào câu SQL:
  ✗ $pdo->query("SELECT * FROM users WHERE name = ''$name''"); // chèn SQL độc
  ✓ prepared: prepare("... WHERE name = ?")->execute([$name]);

XSS (Cross-Site Scripting) — in input người dùng ra HTML chưa escape:
  ✗ echo $_GET["q"];                       // <script> của kẻ gian sẽ chạy
  ✓ echo htmlspecialchars($_GET["q"], ENT_QUOTES, "UTF-8");

CSRF — kẻ gian giả request thay người đã đăng nhập:
  ✓ token CSRF ẩn trong form, kiểm tra khi POST (dùng hash_equals để so sánh).

MẬT KHẨU — KHÔNG lưu dạng thô:
  $hash = password_hash($pw, PASSWORD_DEFAULT);   // bcrypt/argon2 tự thêm salt
  if (password_verify($input, $hash)) { /* đúng */ }

KHÁC:
  • Production: display_errors = 0 (đừng lộ lỗi/đường dẫn), ghi log riêng.
  • Validate + ép kiểu MỌI input; giới hạn loại/kích thước file upload.
  • HTTPS + cookie HttpOnly/Secure/SameSite cho session.

MẸO: quy tắc vàng — KHÔNG tin dữ liệu người dùng. ESCAPE khi XUẤT
(HTML/SQL/shell), VALIDATE khi NHẬP. Dùng password_hash (tuyệt đối đừng
md5/sha1 cho mật khẩu). Framework lo sẵn phần lớn (CSRF token, auto-escape
trong template).',
'Common web vulnerabilities and how to block them in PHP:

SQL INJECTION - concatenating input into SQL:
  ✗ $pdo->query("SELECT * FROM users WHERE name = ''$name''"); // injects SQL
  ✓ prepared: prepare("... WHERE name = ?")->execute([$name]);

XSS (Cross-Site Scripting) - echoing user input into HTML unescaped:
  ✗ echo $_GET["q"];                       // an attacker <script> would run
  ✓ echo htmlspecialchars($_GET["q"], ENT_QUOTES, "UTF-8");

CSRF - an attacker forges a request as a logged-in user:
  ✓ a hidden CSRF token in the form, checked on POST (compare with hash_equals).

PASSWORDS - do NOT store them raw:
  $hash = password_hash($pw, PASSWORD_DEFAULT);   // bcrypt/argon2, auto-salted
  if (password_verify($input, $hash)) { /* correct */ }

OTHER:
  • Production: display_errors = 0 (do not leak errors/paths), log separately.
  • Validate + cast ALL input; limit uploaded file type/size.
  • HTTPS + HttpOnly/Secure/SameSite cookies for sessions.

TIP: the golden rule - do NOT trust user data. ESCAPE on OUTPUT
(HTML/SQL/shell), VALIDATE on INPUT. Use password_hash (never md5/sha1 for
passwords). Frameworks handle most of this (CSRF tokens, auto-escaping in
templates).',
'[]',520,-240),

-- ------------------------- HIỆN ĐẠI -------------------------------
('n_php_php8','Tính năng PHP 8.x','Backend',
'PHP 8.x nhanh hơn (có JIT) và thêm nhiều cú pháp hiện đại đáng dùng:

NULLSAFE (?->): tránh chuỗi if kiểm null lồng nhau:
  $city = $user?->address?->city;   // null nếu bất kỳ khâu nào null

MATCH (thay switch: so sánh CHẶT ===, TRẢ giá trị, không fall-through):
  $label = match($code) {
    200, 201 => "success",
    404      => "not found",
    default  => "unknown",
  };

CONSTRUCTOR PROPERTY PROMOTION:
  class Point { public function __construct(public int $x, public int $y) {} }

ENUM (PHP 8.1) — thay các hằng string rời rạc:
  enum Status: string { case Active = "active"; case Banned = "banned"; }
  Status::Active->value;            // "active"

READONLY property (8.1): thuộc tính chỉ gán 1 lần -> DTO bất biến.
NAMED ARGUMENTS: htmlspecialchars($s, double_encode: false);
FIRST-CLASS CALLABLE (8.1): $fn = strlen(...);
ATTRIBUTES (#[Route(...)]) — metadata thay annotation trong docblock.

MẸO: match an toàn hơn switch (không quên break, so sánh ===). enum thay
"magic string". readonly cho object bất biến. Nâng lên PHP 8.1+ để tận dụng
và nhanh hơn hẳn PHP 7.',
'PHP 8.x is faster (has a JIT) and adds many modern, worthwhile syntaxes:

NULLSAFE (?->): avoid nested null-check if-chains:
  $city = $user?->address?->city;   // null if any link is null

MATCH (replaces switch: STRICT === comparison, RETURNS a value, no fall-through):
  $label = match($code) {
    200, 201 => "success",
    404      => "not found",
    default  => "unknown",
  };

CONSTRUCTOR PROPERTY PROMOTION:
  class Point { public function __construct(public int $x, public int $y) {} }

ENUM (PHP 8.1) - replaces scattered string constants:
  enum Status: string { case Active = "active"; case Banned = "banned"; }
  Status::Active->value;            // "active"

READONLY property (8.1): assigned once -> immutable DTOs.
NAMED ARGUMENTS: htmlspecialchars($s, double_encode: false);
FIRST-CLASS CALLABLE (8.1): $fn = strlen(...);
ATTRIBUTES (#[Route(...)]) - metadata replacing docblock annotations.

TIP: match is safer than switch (no forgotten break, === comparison). enums
replace "magic strings". readonly for immutable objects. Move to PHP 8.1+ to
benefit and to be much faster than PHP 7.',
'[]',640,-260),

('n_php_psr','PSR & Công cụ chuẩn','Backend',
'PSR (PHP Standards Recommendations) là các chuẩn chung do PHP-FIG đặt ra,
giúp code và thư viện tương thích nhau:

  • PSR-1 / PSR-12 : coding style (đặt tên, thụt lề, khoảng trắng).
  • PSR-4          : autoload namespace -> thư mục (Composer dùng).
  • PSR-3          : LoggerInterface -> đổi thư viện log không sửa code.
  • PSR-7 / PSR-15 : HTTP message & middleware (Request/Response chuẩn).
  • PSR-11         : Container interface (dependency injection).

CÔNG CỤ HAY DÙNG:
  • Composer      : quản lý gói + autoload.
  • PHPUnit       : unit test.
  • PHPStan/Psalm : phân tích TĨNH, bắt lỗi kiểu mà không cần chạy.
  • PHP-CS-Fixer / phpcs : tự sửa / kiểm tra style theo PSR-12.

Ý NGHĨA: nhờ PSR + Composer, các thư viện PHP hiện đại ghép nối rất dễ (một
Logger PSR-3 thay cho cái khác mà KHÔNG phải sửa code phụ thuộc).

MẸO: theo PSR-12 + chạy PHPStan ở mức cao trong CI -> code sạch, ít bug,
đội đọc code của nhau dễ. Đây là chuẩn nghề của PHP hiện đại, khác hẳn kiểu
PHP chắp vá ngày xưa.',
'PSR (PHP Standards Recommendations) are shared standards from PHP-FIG that
make code and libraries interoperable:

  • PSR-1 / PSR-12 : coding style (naming, indentation, whitespace).
  • PSR-4          : namespace -> directory autoloading (used by Composer).
  • PSR-3          : LoggerInterface -> swap logging libraries without code changes.
  • PSR-7 / PSR-15 : HTTP messages & middleware (standard Request/Response).
  • PSR-11         : Container interface (dependency injection).

COMMON TOOLS:
  • Composer      : dependency manager + autoload.
  • PHPUnit       : unit testing.
  • PHPStan/Psalm : STATIC analysis, catching type bugs without running.
  • PHP-CS-Fixer / phpcs : auto-fix / check style per PSR-12.

WHY IT MATTERS: thanks to PSR + Composer, modern PHP libraries plug together
easily (one PSR-3 Logger replaces another WITHOUT editing dependent code).

TIP: follow PSR-12 + run PHPStan at a high level in CI -> clean code, fewer
bugs, easier to read each other code. This is professional modern PHP,
unlike the patchwork PHP of old.',
'[]',720,-240),

('n_php_frameworks','Framework & Runtime (FPM/OPcache)','Backend',
'PHP hiếm khi viết thuần trong dự án thật; đa số dùng framework để có cấu
trúc, bảo mật và ORM sẵn.

LARAVEL — phổ biến nhất, "batteries included", cú pháp thanh lịch:
  Route::get("/users/{id}", [UserController::class, "show"]);
  // ORM Eloquent:
  User::where("active", true)->get();
  // sẵn có: routing, migration, queue, auth, Blade template, artisan CLI.

SYMFONY — mô-đun, mạnh, nhiều component tái dùng (Laravel dùng lại nhiều
component của Symfony). Hợp dự án lớn / enterprise.
KHÁC: Slim (micro API), CodeIgniter (nhẹ), Laminas.

RUNTIME — chạy PHP nhanh ở production:
  • PHP-FPM  : quản lý một pool tiến trình PHP; Nginx đẩy request qua FPM.
  • OPcache  : cache BYTECODE đã biên dịch -> KHÔNG parse lại .php mỗi
    request (tăng tốc rất lớn; luôn bật ở production).
  • Preloading (7.4+), JIT (8.0): tăng tốc thêm cho tải nặng.

MẸO: mới học nên bắt đầu với Laravel (tài liệu tốt, cộng đồng lớn, dựng
CRUD/API rất nhanh). Luôn bật OPcache trên production. Framework lo sẵn
routing + bảo mật (CSRF, auto-escape) nên an toàn hơn tự viết thuần nhiều.',
'PHP is rarely written raw in real projects; most use a framework for
structure, security, and a ready ORM.

LARAVEL - the most popular, "batteries included", elegant syntax:
  Route::get("/users/{id}", [UserController::class, "show"]);
  // Eloquent ORM:
  User::where("active", true)->get();
  // built in: routing, migrations, queues, auth, Blade templates, artisan CLI.

SYMFONY - modular, powerful, many reusable components (Laravel reuses many
Symfony components). Suits large / enterprise projects.
OTHERS: Slim (micro APIs), CodeIgniter (lightweight), Laminas.

RUNTIME - running PHP fast in production:
  • PHP-FPM  : manages a pool of PHP processes; Nginx forwards requests to FPM.
  • OPcache  : caches compiled BYTECODE -> does NOT re-parse .php each
    request (a big speedup; always enable in production).
  • Preloading (7.4+), JIT (8.0): extra speed for heavy loads.

TIP: beginners should start with Laravel (great docs, big community, very
fast CRUD/API scaffolding). Always enable OPcache in production. Frameworks
handle routing + security (CSRF, auto-escaping), so they are much safer than
hand-rolled raw PHP.',
'[]',700,-180)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ===== seed_php_edges =====
-- TOPIC PHP: edges
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_php','root','t_php','part-of'),
('e_t_php_s_basics','t_php','s_php_basics','part-of'),
('e_t_php_s_oop','t_php','s_php_oop','part-of'),
('e_t_php_s_web','t_php','s_php_web','part-of'),
('e_t_php_s_modern','t_php','s_php_modern','part-of'),
-- basics
('e_s_php_basics_syntax','s_php_basics','n_php_syntax','part-of'),
('e_s_php_basics_types','s_php_basics','n_php_types','part-of'),
('e_s_php_basics_arrays','s_php_basics','n_php_arrays','part-of'),
('e_s_php_basics_functions','s_php_basics','n_php_functions','part-of'),
-- oop
('e_s_php_oop_oop','s_php_oop','n_php_oop','part-of'),
('e_s_php_oop_traits','s_php_oop','n_php_traits','part-of'),
('e_s_php_oop_namespaces','s_php_oop','n_php_namespaces','part-of'),
-- web
('e_s_php_web_request','s_php_web','n_php_request','part-of'),
('e_s_php_web_superglobals','s_php_web','n_php_superglobals','part-of'),
('e_s_php_web_pdo','s_php_web','n_php_pdo','part-of'),
('e_s_php_web_security','s_php_web','n_php_security','part-of'),
-- modern
('e_s_php_modern_php8','s_php_modern','n_php_php8','part-of'),
('e_s_php_modern_psr','s_php_modern','n_php_psr','part-of'),
('e_s_php_modern_frameworks','s_php_modern','n_php_frameworks','part-of'),
-- related
('e_php_pdo_security','n_php_pdo','n_php_security','related'),
('e_php_pdo_frameworks','n_php_pdo','n_php_frameworks','related'),
('e_php_namespaces_psr','n_php_namespaces','n_php_psr','related'),
('e_php_request_frameworks','n_php_request','n_php_frameworks','related'),
('e_php_oop_traits','n_php_oop','n_php_traits','related'),
('e_php_superglobals_security','n_php_superglobals','n_php_security','related'),
('e_php_pdo_t_mysql','n_php_pdo','t_mysql','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);

-- ===== seed_docker_1 =====
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

-- ===== seed_docker_2 =====
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

-- ===== seed_docker_edges =====
-- TOPIC Docker: edges
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_docker','root','t_docker','part-of'),
('e_t_docker_s_core','t_docker','s_dk_core','part-of'),
('e_t_docker_s_run','t_docker','s_dk_run','part-of'),
('e_t_docker_s_ops','t_docker','s_dk_ops','part-of'),
-- core
('e_s_dk_core_concept','s_dk_core','n_dk_concept','part-of'),
('e_s_dk_core_dockerfile','s_dk_core','n_dk_dockerfile','part-of'),
('e_s_dk_core_layers','s_dk_core','n_dk_layers','part-of'),
('e_s_dk_core_registry','s_dk_core','n_dk_registry','part-of'),
-- run
('e_s_dk_run_volumes','s_dk_run','n_dk_volumes','part-of'),
('e_s_dk_run_networks','s_dk_run','n_dk_networks','part-of'),
('e_s_dk_run_ports_env','s_dk_run','n_dk_ports_env','part-of'),
('e_s_dk_run_compose','s_dk_run','n_dk_compose','part-of'),
-- ops
('e_s_dk_ops_multistage','s_dk_ops','n_dk_multistage','part-of'),
('e_s_dk_ops_bestpractice','s_dk_ops','n_dk_bestpractice','part-of'),
('e_s_dk_ops_ops','s_dk_ops','n_dk_ops','part-of'),
-- related
('e_dk_dockerfile_layers','n_dk_dockerfile','n_dk_layers','related'),
('e_dk_layers_multistage','n_dk_layers','n_dk_multistage','related'),
('e_dk_multistage_bestpractice','n_dk_multistage','n_dk_bestpractice','related'),
('e_dk_compose_networks','n_dk_compose','n_dk_networks','related'),
('e_dk_compose_volumes','n_dk_compose','n_dk_volumes','related'),
('e_dk_dockerfile_registry','n_dk_dockerfile','n_dk_registry','related'),
('e_t_docker_t_ms','t_docker','t_ms','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);

-- ===== seed_net_1 =====
-- ===================================================================
--  TOPIC: Network (song ngữ VI + EN, sơ đồ). File 1: cấu trúc + Model + App
-- ===================================================================
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_net','Mạng máy tính (Network)','System Design',
'Kiến thức mạng cho lập trình web: mô hình OSI/TCP-IP, IP & subnet, TCP vs
UDP, cổng, DNS, HTTP/HTTPS & TLS, REST, cùng hạ tầng NAT/firewall, load
balancer, proxy và CDN.',
'Networking for web developers: the OSI/TCP-IP models, IP & subnets, TCP vs
UDP, ports, DNS, HTTP/HTTPS & TLS, REST, plus infrastructure - NAT/firewall,
load balancers, proxies, and CDNs.',
'[]',480,360),

('s_net_model','Mô hình & Giao thức nền','System Design',
'Mô hình OSI/TCP-IP, địa chỉ IP & subnet, TCP vs UDP, và cổng (ports).',
'The OSI/TCP-IP models, IP addressing & subnets, TCP vs UDP, and ports.',
'[]',380,300),
('s_net_app','Tầng ứng dụng (Web)','System Design',
'DNS, HTTP/HTTPS, TLS/SSL và thiết kế REST API.',
'DNS, HTTP/HTTPS, TLS/SSL, and REST API design.',
'[]',580,300),
('s_net_infra','Hạ tầng mạng','System Design',
'NAT & firewall, load balancer, forward/reverse proxy, và CDN.',
'NAT & firewall, load balancers, forward/reverse proxies, and CDNs.',
'[]',480,240),

-- ------------------------- MODEL ----------------------------------
('n_net_model','Mô hình OSI & TCP/IP','System Design',
'Mô hình phân tầng mô tả dữ liệu đi qua mạng theo các lớp, mỗi lớp một
nhiệm vụ riêng.

TCP/IP (4 tầng — thực dụng, dùng thật):
  4. Application : HTTP, DNS, SMTP, SSH (dữ liệu ứng dụng)
  3. Transport   : TCP / UDP (cổng, độ tin cậy)
  2. Internet    : IP (định tuyến gói giữa các mạng, địa chỉ IP)
  1. Link        : Ethernet / WiFi (khung, địa chỉ MAC, vật lý)

OSI (7 tầng — lý thuyết, hay hỏi phỏng vấn):
  7 Application | 6 Presentation | 5 Session | 4 Transport
  3 Network | 2 Data Link | 1 Physical

ĐÓNG GÓI (encapsulation): mỗi tầng thêm header của nó khi gửi XUỐNG, gỡ ra
khi nhận LÊN:
  [App data] -> +TCP header -> +IP header -> +Ethernet header -> bit lên dây

DÒNG CHẢY: dữ liệu app -> chia segment (TCP) -> đóng gói (IP, thêm địa chỉ
đích) -> khung (MAC) -> tín hiệu; bên nhận gỡ ngược lại từng tầng.

MẸO: nhớ 4 tầng TCP/IP là đủ dùng thực tế. HTTP ở tầng App, chạy TRÊN TCP
(Transport), TCP chạy trên IP (Internet). Biết tầng nào lo gì giúp debug
đúng chỗ: mất gói -> Transport; sai route -> Internet; phân giải tên -> App.',
'A layered model describes data crossing a network in layers, each with one
job.

TCP/IP (4 layers - practical, used in reality):
  4. Application : HTTP, DNS, SMTP, SSH (application data)
  3. Transport   : TCP / UDP (ports, reliability)
  2. Internet    : IP (routing packets between networks, IP addresses)
  1. Link        : Ethernet / WiFi (frames, MAC addresses, physical)

OSI (7 layers - theoretical, common in interviews):
  7 Application | 6 Presentation | 5 Session | 4 Transport
  3 Network | 2 Data Link | 1 Physical

ENCAPSULATION: each layer adds its header going DOWN and strips it going UP:
  [App data] -> +TCP header -> +IP header -> +Ethernet header -> bits on the wire

FLOW: app data -> split into segments (TCP) -> packets (IP, adds the
destination address) -> frames (MAC) -> signals; the receiver unwraps each
layer in reverse.

TIP: knowing the 4 TCP/IP layers is enough in practice. HTTP is at the App
layer, runs OVER TCP (Transport), which runs over IP (Internet). Knowing
which layer does what helps debug: packet loss -> Transport; bad route ->
Internet; name resolution -> App.',
'[]',320,340),

('n_net_ip','Địa chỉ IP & Subnet','System Design',
'Địa chỉ IP định danh một thiết bị trên mạng để gói tin tìm đường tới.
IPv4: 4 số 0-255 (32-bit), vd 192.168.1.10. IPv6: 128-bit (vô số địa chỉ),
vd 2001:db8::1.

PUBLIC vs PRIVATE:
  • Private (mạng nội bộ, không ra Internet trực tiếp):
    10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
  • Public: cấp phát toàn cầu, định tuyến được trên Internet.
  • Loopback: 127.0.0.1 (localhost).

SUBNET & CIDR: /n = số bit của phần MẠNG; phần còn lại là HOST.
  192.168.1.0/24  -> 24 bit mạng, 8 bit host -> 256 địa chỉ (254 dùng được)
  10.0.0.0/16     -> 65,536 địa chỉ
  -> số sau "/" càng LỚN thì mạng càng NHỎ (ít host hơn).
  subnet mask của /24 = 255.255.255.0

Ý NGHĨA: chia subnet để tách mạng, kiểm soát định tuyến & bảo mật (vd VPC
trên AWS chia subnet public/private).
GATEWAY: cổng ra (router) để gói rời mạng nội bộ; DHCP tự cấp IP cho thiết bị.

MẸO: nhớ 3 dải private + 127.0.0.1. CIDR /24 (256 IP) rất hay gặp trong
LAN/VPC. Càng nhiều bit mạng (/n lớn) -> càng ít địa chỉ host khả dụng.',
'An IP address identifies a device on a network so packets can find their
way. IPv4: four 0-255 numbers (32-bit), e.g. 192.168.1.10. IPv6: 128-bit
(vast address space), e.g. 2001:db8::1.

PUBLIC vs PRIVATE:
  • Private (internal, not directly on the Internet):
    10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
  • Public: globally allocated, routable on the Internet.
  • Loopback: 127.0.0.1 (localhost).

SUBNET & CIDR: /n = the number of NETWORK bits; the rest is HOST.
  192.168.1.0/24  -> 24 network bits, 8 host bits -> 256 addresses (254 usable)
  10.0.0.0/16     -> 65,536 addresses
  -> a LARGER number after "/" means a SMALLER network (fewer hosts).
  the /24 subnet mask = 255.255.255.0

MEANING: subnetting separates networks and controls routing & security
(e.g. an AWS VPC splits public/private subnets).
GATEWAY: the exit (router) for packets leaving the local network; DHCP
auto-assigns IPs to devices.

TIP: memorize the 3 private ranges + 127.0.0.1. CIDR /24 (256 IPs) is very
common in LANs/VPCs. More network bits (larger /n) -> fewer usable host
addresses.',
'[]',300,300),

('n_net_tcp_udp','TCP vs UDP','System Design',
'Tầng Transport có hai giao thức chính, đánh đổi TIN CẬY vs TỐC ĐỘ.

TCP (Transmission Control Protocol) — tin cậy, CÓ kết nối:
  • Bắt tay 3 bước trước khi truyền: SYN -> SYN-ACK -> ACK
  • Đảm bảo đến ĐỦ, ĐÚNG THỨ TỰ, không trùng; tự truyền lại gói mất; kiểm
    soát tắc nghẽn.
  • Dùng cho: HTTP/HTTPS, SSH, email, DB — nơi cần chính xác.

UDP (User Datagram Protocol) — nhanh, KHÔNG kết nối:
  • Gửi luôn, KHÔNG bắt tay, KHÔNG đảm bảo đến/thứ tự.
  • Nhẹ, độ trễ thấp.
  • Dùng cho: video/voice call, game realtime, DNS, streaming — nơi tốc độ
    quan trọng hơn việc mất vài gói.

SO SÁNH nhanh:
  TCP: chậm hơn, nặng hơn, ĐÁNG TIN   -> như "gọi điện xác nhận từng câu"
  UDP: nhanh, nhẹ, CÓ THỂ MẤT gói     -> như "phát loa, ai nghe kịp thì nghe"

HTTP/3 (QUIC) chạy trên UDP nhưng tự thêm độ tin cậy ở tầng trên.

MẸO: cần dữ liệu nguyên vẹn -> TCP; cần realtime chấp nhận mất mát -> UDP.
Câu phỏng vấn kinh điển: mô tả 3-way handshake và khác biệt TCP/UDP.',
'The Transport layer has two main protocols, trading RELIABILITY vs SPEED.

TCP (Transmission Control Protocol) - reliable, CONNECTION-oriented:
  • A 3-way handshake before sending: SYN -> SYN-ACK -> ACK
  • Guarantees COMPLETE, IN-ORDER, non-duplicated delivery; retransmits lost
    packets; congestion control.
  • Used for: HTTP/HTTPS, SSH, email, DBs - where accuracy matters.

UDP (User Datagram Protocol) - fast, CONNECTIONLESS:
  • Just sends, NO handshake, NO delivery/order guarantee.
  • Lightweight, low latency.
  • Used for: video/voice calls, realtime games, DNS, streaming - where speed
    beats losing a few packets.

QUICK COMPARISON:
  TCP: slower, heavier, RELIABLE   -> like "a phone call confirming each line"
  UDP: fast, light, MAY LOSE packets -> like "a loudspeaker - catch it if you can"

HTTP/3 (QUIC) runs over UDP but adds its own reliability on top.

TIP: need intact data -> TCP; need realtime tolerating loss -> UDP. A classic
interview question: describe the 3-way handshake and the TCP/UDP difference.',
'[]',360,260),

('n_net_ports','Cổng (Ports)','System Design',
'Cổng (port) là số 0-65535 giúp một máy (một IP) phân biệt NHIỀU dịch vụ /
kết nối cùng lúc. IP tìm đúng MÁY, port tìm đúng ỨNG DỤNG.
  Một kết nối được xác định bởi bộ 4: (IP nguồn, port nguồn, IP đích, port đích).

CỔNG PHỔ BIẾN (well-known, 0-1023):
  80   HTTP         443  HTTPS        22   SSH
  53   DNS          25   SMTP         3306 MySQL
  5432 PostgreSQL   6379 Redis        27017 MongoDB
  3000 / 8080 thường dùng cho app khi dev

PHÂN LOẠI:
  0-1023      well-known (dịch vụ hệ thống)
  1024-49151  registered
  49152-65535 ephemeral (client tự cấp tạm cho kết nối ra)

VÍ DỤ: trình duyệt mở kết nối từ một port ngẫu nhiên (vd 51000) tới server
port 443; server trả về đúng kết nối đó nhờ bộ 4 nói trên.
LIÊN HỆ DOCKER: "-p 8080:80" map port 8080 của host -> port 80 của container.

MẸO: thuộc vài port hay gặp (80/443/22/3306/5432/6379). "IP:cổng" giống
"tòa nhà:số phòng". Firewall thường lọc theo port (mở 443, chặn phần còn lại).',
'A port is a number 0-65535 that lets one machine (one IP) distinguish MANY
services / connections at once. IP finds the right MACHINE, the port finds
the right APPLICATION.
  A connection is identified by a 4-tuple: (src IP, src port, dst IP, dst port).

COMMON PORTS (well-known, 0-1023):
  80   HTTP         443  HTTPS        22   SSH
  53   DNS          25   SMTP         3306 MySQL
  5432 PostgreSQL   6379 Redis        27017 MongoDB
  3000 / 8080 often used for apps during development

RANGES:
  0-1023      well-known (system services)
  1024-49151  registered
  49152-65535 ephemeral (client-assigned temporarily for outbound connections)

EXAMPLE: a browser opens a connection from a random port (e.g. 51000) to the
server port 443; the server replies to that exact connection via the 4-tuple.
DOCKER LINK: "-p 8080:80" maps host port 8080 -> container port 80.

TIP: memorize a few common ports (80/443/22/3306/5432/6379). "IP:port" is
like "building:room number". Firewalls often filter by port (open 443, block
the rest).',
'[]',420,300),

-- ------------------------- APP ------------------------------------
('n_net_dns','DNS','System Design',
'DNS (Domain Name System) là "danh bạ" của Internet: dịch tên miền
(google.com) sang địa chỉ IP mà máy dùng để kết nối. Người nhớ tên, máy
cần IP.

PHÂN GIẢI (khi gõ example.com):
  1. Trình duyệt/OS xem CACHE cục bộ -> có thì dùng luôn.
  2. Hỏi RESOLVER (thường của ISP, hoặc 8.8.8.8 / 1.1.1.1).
  3. Resolver hỏi ROOT -> TLD (.com) -> NAMESERVER của domain.
  4. Nhận IP -> trả về -> trình duyệt kết nối tới IP đó.
  (kết quả được cache theo TTL để lần sau nhanh hơn)

CÁC BẢN GHI (records):
  A     tên -> IPv4          AAAA  tên -> IPv6
  CNAME bí danh -> tên khác  MX    máy chủ mail
  TXT   văn bản (SPF, xác minh)   NS   nameserver
  -> A/AAAA và CNAME là hay gặp nhất.

TTL: thời gian cache một bản ghi (giây). TTL thấp -> đổi IP lan nhanh nhưng
nhiều truy vấn hơn.

MẸO: đổi DNS cần thời gian "lan" (propagation) do cache/TTL. Công cụ:
nslookup, dig. DNS chạy chủ yếu trên UDP cổng 53. CDN/load balancer thường
dùng CNAME + DNS để định tuyến người dùng.',
'DNS (Domain Name System) is the Internet "phone book": it translates a
domain name (google.com) into the IP address a machine uses to connect.
People remember names, machines need IPs.

RESOLUTION (when you type example.com):
  1. The browser/OS checks its local CACHE -> use it if present.
  2. Ask a RESOLVER (usually the ISP, or 8.8.8.8 / 1.1.1.1).
  3. The resolver asks ROOT -> TLD (.com) -> the domain NAMESERVER.
  4. Gets the IP -> returns it -> the browser connects to that IP.
  (the result is cached per TTL to be faster next time)

RECORDS:
  A     name -> IPv4         AAAA  name -> IPv6
  CNAME alias -> another name MX   mail server
  TXT   text (SPF, verification)   NS   nameserver
  -> A/AAAA and CNAME are the most common.

TTL: how long a record is cached (seconds). A low TTL -> IP changes propagate
fast but cause more queries.

TIP: DNS changes need "propagation" time due to caching/TTL. Tools: nslookup,
dig. DNS runs mostly over UDP port 53. CDNs/load balancers often use CNAME +
DNS to route users.',
'[]',560,340),

('n_net_http','HTTP & Status Codes','System Design',
'HTTP là giao thức tầng ứng dụng cho web: client gửi REQUEST, server trả
RESPONSE (mô hình request/response, PHI TRẠNG THÁI - stateless).

CẤU TRÚC REQUEST:
  GET /users/42 HTTP/1.1          <- method + path + version
  Host: api.example.com           <- headers
  Authorization: Bearer <token>
  (body — với POST/PUT)

METHODS: GET (đọc), POST (tạo), PUT (thay toàn bộ), PATCH (sửa một phần),
DELETE (xóa), HEAD, OPTIONS.

RESPONSE:
  HTTP/1.1 200 OK                 <- status code
  Content-Type: application/json
  {"id":42, ...}                  <- body

STATUS CODES (theo nhóm):
  2xx thành công : 200 OK, 201 Created, 204 No Content
  3xx chuyển hướng: 301 (vĩnh viễn), 302 (tạm), 304 Not Modified
  4xx lỗi CLIENT : 400 Bad Request, 401 Unauthorized, 403 Forbidden,
                   404 Not Found, 429 Too Many Requests
  5xx lỗi SERVER : 500 Internal, 502 Bad Gateway, 503 Unavailable

STATELESS: mỗi request độc lập -> giữ phiên bằng cookie/token.
PHIÊN BẢN: HTTP/1.1 (text), HTTP/2 (nhị phân, đa luồng trên 1 kết nối),
HTTP/3 (trên QUIC/UDP).

MẸO: nhớ ý nghĩa nhóm status (4xx tại CLIENT, 5xx tại SERVER) để debug
nhanh. Dùng method đúng ngữ nghĩa (GET không được làm đổi dữ liệu).',
'HTTP is the web application-layer protocol: the client sends a REQUEST, the
server returns a RESPONSE (request/response model, STATELESS).

REQUEST STRUCTURE:
  GET /users/42 HTTP/1.1          <- method + path + version
  Host: api.example.com           <- headers
  Authorization: Bearer <token>
  (body — with POST/PUT)

METHODS: GET (read), POST (create), PUT (replace whole), PATCH (partial
update), DELETE (remove), HEAD, OPTIONS.

RESPONSE:
  HTTP/1.1 200 OK                 <- status code
  Content-Type: application/json
  {"id":42, ...}                  <- body

STATUS CODES (by class):
  2xx success  : 200 OK, 201 Created, 204 No Content
  3xx redirect : 301 (permanent), 302 (temporary), 304 Not Modified
  4xx CLIENT error: 400 Bad Request, 401 Unauthorized, 403 Forbidden,
                    404 Not Found, 429 Too Many Requests
  5xx SERVER error: 500 Internal, 502 Bad Gateway, 503 Unavailable

STATELESS: each request is independent -> keep sessions via cookies/tokens.
VERSIONS: HTTP/1.1 (text), HTTP/2 (binary, multiplexed on one connection),
HTTP/3 (over QUIC/UDP).

TIP: remember the status classes (4xx is CLIENT, 5xx is SERVER) to debug
fast. Use methods per their semantics (GET must not change data).',
'[]',620,300),

('n_net_tls','TLS / HTTPS','System Design',
'TLS/SSL mã hóa kết nối -> HTTPS = HTTP chạy TRÊN TLS. Bảo vệ 3 điều: BÍ MẬT
(mã hóa), TOÀN VẸN (không bị sửa), XÁC THỰC (đúng server nhờ certificate).

TLS HANDSHAKE (rút gọn):
  1. Client Hello: gửi phiên bản TLS + danh sách cipher hỗ trợ.
  2. Server gửi CERTIFICATE (chứa public key, do CA ký).
  3. Client kiểm tra cert: CA có tin cậy? đúng domain? còn hạn?
  4. Hai bên thống nhất KHÓA PHIÊN (session key) qua mã hóa bất đối xứng.
  5. Truyền dữ liệu bằng mã hóa ĐỐI XỨNG (nhanh) với session key.

CHỨNG CHỈ: CA (Certificate Authority) ký xác nhận domain. "Let''s Encrypt"
cấp miễn phí (Certbot tự gia hạn — như trong phần deploy của app này).

MÃ HÓA:
  • Bất đối xứng (public/private key): dùng lúc handshake để trao khóa.
  • Đối xứng (một khóa chung): dùng cho dữ liệu (nhanh hơn nhiều).

MẸO: HTTPS (ổ khóa) nghĩa là kết nối được mã hóa + server đã được xác thực
(KHÔNG bảo đảm website "tốt/an toàn về nội dung"). Luôn dùng HTTPS. Cert hết
hạn -> trình duyệt cảnh báo -> nhớ auto-renew (Certbot).',
'TLS/SSL encrypts the connection -> HTTPS = HTTP OVER TLS. It protects three
things: CONFIDENTIALITY (encryption), INTEGRITY (not tampered), AUTHENTICITY
(the right server, via a certificate).

TLS HANDSHAKE (simplified):
  1. Client Hello: sends the TLS version + supported cipher list.
  2. The server sends its CERTIFICATE (contains a public key, signed by a CA).
  3. The client verifies the cert: trusted CA? right domain? not expired?
  4. Both agree on a SESSION KEY via asymmetric encryption.
  5. Data is transferred with SYMMETRIC encryption (much faster) using that key.

CERTIFICATES: a CA (Certificate Authority) signs to vouch for a domain.
"Let''s Encrypt" issues them free (Certbot auto-renews - as in this app deploy).

ENCRYPTION:
  • Asymmetric (public/private key): used during the handshake to exchange a key.
  • Symmetric (one shared key): used for the data (much faster).

TIP: HTTPS (the padlock) means the connection is encrypted + the server is
authenticated (it does NOT guarantee the site content is "safe/good").
Always use HTTPS. An expired cert -> browser warning -> remember auto-renew
(Certbot).',
'[]',640,260),

('n_net_rest','Thiết kế REST API','System Design',
'REST là kiểu thiết kế API dựa trên HTTP: coi mọi thứ là TÀI NGUYÊN
(resource) có URL, thao tác bằng HTTP method.

NGUYÊN TẮC:
  • Resource là DANH TỪ, số nhiều: /users, /users/42, /users/42/orders
  • Method mang ngữ nghĩa hành động (ĐỪNG nhét động từ vào URL):
      GET    /users        lấy danh sách
      GET    /users/42     lấy một user
      POST   /users        tạo mới
      PUT    /users/42     thay toàn bộ
      PATCH  /users/42     sửa một phần
      DELETE /users/42     xóa
  ✗ /getUser?id=42 hay /createUser    ✓ GET /users/42, POST /users
  • Stateless: request tự chứa đủ thông tin (token); server không giữ phiên.
  • Trả status code đúng (201 khi tạo, 404 khi không thấy...).
  • Dữ liệu thường ở dạng JSON.

KHÁC: GraphQL (một endpoint, client chọn field cần), gRPC (nhị phân, hợp
giao tiếp nội bộ service).

MẸO: URL theo tài nguyên + đúng method + đúng status code = 80% của một
REST API tốt. Thêm versioning (/v1/) và phân trang (?page=&limit=) cho API
công khai. Quan trọng nhất là NHẤT QUÁN toàn API.',
'REST is an HTTP-based API design style: treat everything as a RESOURCE with
a URL, acted on via HTTP methods.

PRINCIPLES:
  • Resources are NOUNS, plural: /users, /users/42, /users/42/orders
  • Methods carry the action meaning (do NOT put verbs in the URL):
      GET    /users        list
      GET    /users/42     get one user
      POST   /users        create
      PUT    /users/42     replace whole
      PATCH  /users/42     partial update
      DELETE /users/42     remove
  ✗ /getUser?id=42 or /createUser    ✓ GET /users/42, POST /users
  • Stateless: the request carries all it needs (token); the server keeps no session.
  • Return correct status codes (201 on create, 404 when not found...).
  • Data is usually JSON.

OTHERS: GraphQL (one endpoint, the client picks fields), gRPC (binary, good
for internal service-to-service).

TIP: resource-based URLs + correct methods + correct status codes = 80% of a
good REST API. Add versioning (/v1/) and pagination (?page=&limit=) for public
APIs. Most important: be CONSISTENT across the whole API.',
'[]',680,320)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ===== seed_net_2 =====
-- TOPIC Network file 2: Infra
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('n_net_nat_fw','NAT & Firewall','System Design',
'NAT và Firewall là hai cơ chế nền tảng ở BIÊN mạng.

NAT (Network Address Translation): dịch IP private <-> public, cho NHIỀU
thiết bị nội bộ (192.168.x) chia sẻ MỘT IP public ra Internet.
  Máy nội bộ 192.168.1.5 -> router NAT -> ra Internet bằng IP public của router
  -> router nhớ ánh xạ để trả gói về đúng máy nội bộ.
  Đây là lý do IPv4 chưa cạn dù ít địa chỉ, và máy nhà bạn không có IP public riêng.

FIREWALL: lọc lưu lượng theo LUẬT (cho phép/chặn) dựa trên IP, port, protocol.
  • Nguyên tắc: mặc định CHẶN, chỉ MỞ cổng thật sự cần (vd chỉ 443 vào web).
  • Stateful firewall: nhớ kết nối đang mở -> tự cho gói TRẢ VỀ của kết nối
    do bên trong khởi tạo.
  • Security Group (AWS) là firewall ảo ở mức instance.

VÍ DỤ luật: "inbound: cho phép TCP 443 từ mọi nơi; cho SSH 22 chỉ từ IP văn
phòng; chặn phần còn lại".

MẸO: theo "least privilege" — mặc định chặn, chỉ mở cổng/nguồn cần thiết.
NAT + firewall ở gateway là lớp bảo vệ cơ bản của mọi mạng nội bộ / VPC.',
'NAT and Firewall are two foundational mechanisms at the network EDGE.

NAT (Network Address Translation): translates private <-> public IPs so MANY
internal devices (192.168.x) share ONE public IP to the Internet.
  Internal host 192.168.1.5 -> NAT router -> reaches the Internet as the router public IP
  -> the router remembers the mapping to return packets to the right host.
  This is why IPv4 has not run out despite few addresses, and why your home
  machine has no public IP of its own.

FIREWALL: filters traffic by RULES (allow/deny) based on IP, port, protocol.
  • Principle: deny by default, only OPEN ports truly needed (e.g. only 443 to web).
  • Stateful firewall: remembers open connections -> automatically allows the
    RETURN packets of connections initiated from inside.
  • A Security Group (AWS) is a virtual instance-level firewall.

EXAMPLE RULES: "inbound: allow TCP 443 from anywhere; allow SSH 22 only from
the office IP; deny the rest".

TIP: follow "least privilege" - deny by default, open only necessary
ports/sources. NAT + firewall at the gateway is the basic protection layer of
any internal network / VPC.',
'[]',400,220),

('n_net_lb','Load Balancer','System Design',
'Load Balancer (cân bằng tải) phân phối request tới NHIỀU server backend
-> chịu tải cao + sẵn sàng cao (một server chết vẫn còn server khác).

  Client -> [ Load Balancer ] -> Server 1 / Server 2 / Server 3

THUẬT TOÁN phân phối:
  • Round-robin      : lần lượt từng server.
  • Least connections: chọn server ít kết nối nhất.
  • IP hash          : theo IP client (giữ "dính" một client vào một server).

TẦNG:
  • L4 (transport)  : cân bằng theo IP/port, nhanh, không nhìn nội dung.
  • L7 (application): hiểu HTTP -> định tuyến theo path/host/header
    (vd /api -> nhóm A, /img -> nhóm B).

HEALTH CHECK: LB tự kiểm tra server, NGỪNG gửi request tới server hỏng.
STICKY SESSION: giữ user vào cùng một server (khi state nằm ở server) —
nhưng tốt hơn là làm server STATELESS.

MẸO: LB là nền của SCALE NGANG + HA. Trên AWS: ALB (L7), NLB (L4). Kết hợp
auto-scaling (thêm/bớt server theo tải). Muốn scale mượt -> server nên
STATELESS (đẩy state sang DB/Redis) để gửi request tới server nào cũng được.',
'A load balancer distributes requests across MANY backend servers -> handles
high load + high availability (one server dies, others remain).

  Client -> [ Load Balancer ] -> Server 1 / Server 2 / Server 3

DISTRIBUTION ALGORITHMS:
  • Round-robin      : each server in turn.
  • Least connections: pick the server with the fewest connections.
  • IP hash          : by client IP (keeps a client "stuck" to one server).

LAYERS:
  • L4 (transport)  : balances by IP/port, fast, does not inspect content.
  • L7 (application): understands HTTP -> routes by path/host/header
    (e.g. /api -> group A, /img -> group B).

HEALTH CHECKS: the LB probes servers and STOPS sending to unhealthy ones.
STICKY SESSIONS: pin a user to one server (when state lives on the server) -
but making servers STATELESS is better.

TIP: the LB underpins HORIZONTAL scaling + HA. On AWS: ALB (L7), NLB (L4).
Combine with auto-scaling (add/remove servers by load). For smooth scaling,
make servers STATELESS (push state to DB/Redis) so any server can handle any
request.',
'[]',560,220),

('n_net_proxy','Forward vs Reverse Proxy','System Design',
'Proxy là máy trung gian giữa client và server, chuyển tiếp request. Có hai
loại NGƯỢC nhau:

FORWARD PROXY (đại diện cho CLIENT):
  Client -> [Forward Proxy] -> Internet
  • Ẩn/gom client, lọc nội dung, cache, vượt chặn (VPN / corporate proxy).

REVERSE PROXY (đại diện cho SERVER):
  Client -> [Reverse Proxy] -> Server nội bộ
  • Đứng TRƯỚC server: định tuyến, TLS termination (giải mã HTTPS), cache,
    nén, rate limit, ẩn cấu trúc backend.
  • Nginx, Caddy, HAProxy hay dùng làm reverse proxy (như Nginx/Caddy trong
    phần deploy của app này).

KHÁC LOAD BALANCER: reverse proxy CÓ THỂ kiêm cân bằng tải; LB tập trung vào
phân phối. Nhiều công cụ (Nginx) làm cả hai vai.

VÍ DỤ: Nginx nhận cổng 443 (HTTPS), giải mã TLS, rồi chuyển tiếp HTTP nội bộ
tới app ở 127.0.0.1:3000.

MẸO: "forward = cho client, reverse = cho server". Reverse proxy là nơi đặt
TLS, cache, rate limit và định tuyến tới nhiều service — cực phổ biến trong
kiến trúc web/microservices.',
'A proxy is an intermediary between client and server that forwards requests.
There are two OPPOSITE kinds:

FORWARD PROXY (acts on behalf of the CLIENT):
  Client -> [Forward Proxy] -> Internet
  • Hides/aggregates clients, filters content, caches, bypasses blocks
    (VPN / corporate proxy).

REVERSE PROXY (acts on behalf of the SERVER):
  Client -> [Reverse Proxy] -> internal servers
  • Sits IN FRONT of servers: routing, TLS termination (decrypts HTTPS),
    caching, compression, rate limiting, hiding the backend layout.
  • Nginx, Caddy, HAProxy are common reverse proxies (like Nginx/Caddy in this
    app deploy).

VS A LOAD BALANCER: a reverse proxy CAN also load-balance; an LB focuses on
distribution. Many tools (Nginx) do both.

EXAMPLE: Nginx accepts port 443 (HTTPS), terminates TLS, then forwards plain
HTTP internally to an app at 127.0.0.1:3000.

TIP: "forward = for the client, reverse = for the server". A reverse proxy is
where you place TLS, caching, rate limiting, and routing to many services -
extremely common in web/microservice architectures.',
'[]',600,180),

('n_net_cdn','CDN','System Design',
'CDN (Content Delivery Network) là mạng lưới server đặt ở NHIỀU nơi trên
thế giới (edge / PoP), cache nội dung GẦN người dùng -> tải nhanh, giảm tải
server gốc.

CÁCH HOẠT ĐỘNG:
  User ở VN -> CDN edge tại VN (có cache?) -> trả ngay nếu có
                     | (cache miss)
                     -> lấy từ ORIGIN (server gốc, vd ở Mỹ) rồi cache lại
  -> user VN tiếp theo lấy từ edge VN, không phải "bay" sang Mỹ.

CACHE GÌ: chủ yếu STATIC (ảnh, CSS, JS, video, file). Nội dung động thường
không cache hoặc cache rất ngắn.

LỢI ÍCH:
  • Độ trễ thấp (gần người dùng về địa lý).
  • Giảm tải + băng thông cho origin.
  • Chịu tải đột biến, chống DDoS một phần.

CACHE CONTROL: header Cache-Control / ETag quyết định cache bao lâu; cần
"invalidate" hoặc đổi tên file (thêm hash) khi cập nhật.

VÍ DỤ: CloudFront (AWS), Cloudflare, Fastly, Akamai.

MẸO: đưa asset tĩnh lên CDN là cách tăng tốc web đơn giản mà hiệu quả nhất.
Dùng "cache busting" (thêm hash vào tên file: app.3f9a.js) để user luôn nhận
bản mới sau khi deploy.',
'A CDN (Content Delivery Network) is a network of servers in MANY locations
worldwide (edge / PoP) caching content CLOSE to users -> faster loads, less
load on the origin server.

HOW IT WORKS:
  User in VN -> CDN edge in VN (cached?) -> serve immediately if present
                     | (cache miss)
                     -> fetch from ORIGIN (e.g. in the US) then cache it
  -> the next VN user is served from the VN edge, no round-trip to the US.

WHAT IS CACHED: mostly STATIC assets (images, CSS, JS, video, files). Dynamic
content is usually not cached or cached very briefly.

BENEFITS:
  • Low latency (geographically near users).
  • Less load + bandwidth on the origin.
  • Absorbs traffic spikes, partial DDoS protection.

CACHE CONTROL: Cache-Control / ETag headers decide how long to cache; you must
"invalidate" or rename files (add a hash) on updates.

EXAMPLES: CloudFront (AWS), Cloudflare, Fastly, Akamai.

TIP: putting static assets on a CDN is the simplest, most effective web
speedup. Use "cache busting" (a hash in the filename: app.3f9a.js) so users
always get the new build after a deploy.',
'[]',540,160)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ===== seed_net_edges =====
-- TOPIC Network: edges
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_net','root','t_net','part-of'),
('e_t_net_s_model','t_net','s_net_model','part-of'),
('e_t_net_s_app','t_net','s_net_app','part-of'),
('e_t_net_s_infra','t_net','s_net_infra','part-of'),
-- model
('e_s_net_model_model','s_net_model','n_net_model','part-of'),
('e_s_net_model_ip','s_net_model','n_net_ip','part-of'),
('e_s_net_model_tcpudp','s_net_model','n_net_tcp_udp','part-of'),
('e_s_net_model_ports','s_net_model','n_net_ports','part-of'),
-- app
('e_s_net_app_dns','s_net_app','n_net_dns','part-of'),
('e_s_net_app_http','s_net_app','n_net_http','part-of'),
('e_s_net_app_tls','s_net_app','n_net_tls','part-of'),
('e_s_net_app_rest','s_net_app','n_net_rest','part-of'),
-- infra
('e_s_net_infra_natfw','s_net_infra','n_net_nat_fw','part-of'),
('e_s_net_infra_lb','s_net_infra','n_net_lb','part-of'),
('e_s_net_infra_proxy','s_net_infra','n_net_proxy','part-of'),
('e_s_net_infra_cdn','s_net_infra','n_net_cdn','part-of'),
-- related (nội bộ)
('e_net_model_tcpudp','n_net_model','n_net_tcp_udp','related'),
('e_net_tcpudp_ports','n_net_tcp_udp','n_net_ports','related'),
('e_net_http_tls','n_net_http','n_net_tls','related'),
('e_net_http_rest','n_net_http','n_net_rest','related'),
('e_net_dns_cdn','n_net_dns','n_net_cdn','related'),
('e_net_lb_proxy','n_net_lb','n_net_proxy','related'),
('e_net_natfw_ports','n_net_nat_fw','n_net_ports','related'),
-- related (liên topic)
('e_net_lb_ms_gateway','n_net_lb','n_ms_gateway','related'),
('e_net_proxy_docker','n_net_proxy','t_docker','related'),
('e_net_rest_ms','n_net_rest','n_ms_sync','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);

-- ===== seed_aws_1 =====
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

-- ===== seed_aws_2 =====
-- TOPIC AWS file 2: Data + Ops
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('n_aws_s3','S3 (Object Storage)','DevOps & Cloud',
'S3 (Simple Storage Service) là kho lưu trữ OBJECT (file) gần như vô hạn,
độ bền cực cao. Dùng cho ảnh, video, backup, file tĩnh, data lake.

KHÁI NIỆM:
  • Bucket: "thùng" chứa object, tên DUY NHẤT toàn cầu.
  • Object: file + metadata, định danh bằng KEY (đường dẫn ảo: photos/2025/a.jpg).
  • KHÔNG phải hệ thống file thật (không có thư mục thật, "thư mục" chỉ là
    tiền tố của key).

TÍNH NĂNG:
  • Storage class: Standard (nóng), Intelligent-Tiering, Glacier (lưu trữ
    lạnh, rẻ, lấy chậm) -> tiết kiệm theo tần suất truy cập.
  • Versioning; lifecycle (tự chuyển sang lớp rẻ / xóa sau N ngày).
  • Static website hosting; tích hợp CloudFront (CDN) để phân phối nhanh.
  • Bảo mật: mặc định PRIVATE; quản quyền bằng bucket policy/IAM; mã hóa at-rest.

DÙNG CHO: chứa asset/upload của web (thay vì lưu trên server), backup, log,
data lake, phân phối file tĩnh.

MẸO: đưa file tĩnh/upload lên S3 + CloudFront thay vì giữ trên EC2 -> rẻ,
bền, scale sẵn. CẨN THẬN cấu hình public — bucket mở gây rò rỉ dữ liệu là
sự cố kinh điển; mặc định để PRIVATE, mở có chủ đích.',
'S3 (Simple Storage Service) is near-infinite OBJECT (file) storage with
extremely high durability. Used for images, video, backups, static files,
data lakes.

CONCEPTS:
  • Bucket: a "container" for objects, with a globally UNIQUE name.
  • Object: a file + metadata, identified by a KEY (a virtual path: photos/2025/a.jpg).
  • NOT a real filesystem (no real folders; "folders" are just key prefixes).

FEATURES:
  • Storage classes: Standard (hot), Intelligent-Tiering, Glacier (cold, cheap,
    slow retrieval) -> save cost by access frequency.
  • Versioning; lifecycle (auto-move to cheaper class / delete after N days).
  • Static website hosting; integrates with CloudFront (CDN) for fast delivery.
  • Security: PRIVATE by default; permissions via bucket policy/IAM; at-rest encryption.

USED FOR: hosting web assets/uploads (instead of on a server), backups, logs,
data lakes, static file delivery.

TIP: put static files/uploads on S3 + CloudFront instead of keeping them on
EC2 -> cheap, durable, already scalable. BE CAREFUL with public config - an
open bucket leaking data is a classic incident; keep PRIVATE by default,
open deliberately.',
'[]',700,50),

('n_aws_rds','RDS (SQL quản lý)','DevOps & Cloud',
'RDS (Relational Database Service) là CSDL QUAN HỆ được QUẢN LÝ (MySQL,
PostgreSQL, MariaDB, SQL Server, Oracle, Aurora). AWS lo cài đặt, backup,
patch, nhân bản.

AWS LO GIÙM:
  • Cài đặt, vá lỗi, nâng cấp phiên bản.
  • Backup tự động + snapshot; point-in-time recovery.
  • Multi-AZ: bản standby ở AZ khác, tự chuyển đổi (failover) khi primary sập
    -> HA.
  • Read replica: bản sao CHỈ ĐỌC để chia tải đọc (scale read).

AURORA: DB tương thích MySQL/PostgreSQL do AWS xây, nhanh hơn & tự co giãn
lưu trữ; có Aurora Serverless (tự scale theo tải).

BẠN VẪN LO: thiết kế schema, index, tối ưu query, chọn instance size.

DÙNG CHO: dữ liệu quan hệ cần ACID, giao dịch (đơn hàng, người dùng, tài chính).

MẸO: production nên bật Multi-AZ (HA) + backup. Tải đọc lớn -> thêm read
replica. Không muốn tự quản MySQL trên EC2 -> dùng RDS. Đây là "DB trong
private subnet" điển hình. So với DynamoDB: RDS cho quan hệ/giao dịch phức
tạp; Dynamo cho quy mô key-value cực lớn.',
'RDS (Relational Database Service) is a MANAGED relational database (MySQL,
PostgreSQL, MariaDB, SQL Server, Oracle, Aurora). AWS handles setup, backups,
patching, replication.

AWS HANDLES:
  • Setup, patching, version upgrades.
  • Automated backups + snapshots; point-in-time recovery.
  • Multi-AZ: a standby in another AZ, auto-failover when the primary dies -> HA.
  • Read replicas: READ-only copies to spread read load (scale reads).

AURORA: an AWS-built MySQL/PostgreSQL-compatible DB, faster & auto-scaling
storage; Aurora Serverless auto-scales with load.

YOU STILL HANDLE: schema design, indexes, query tuning, instance sizing.

USED FOR: relational data needing ACID and transactions (orders, users, finance).

TIP: enable Multi-AZ (HA) + backups in production. Heavy read load -> add read
replicas. Do not want to self-manage MySQL on EC2 -> use RDS. This is the
typical "DB in a private subnet". Vs DynamoDB: RDS for complex
relations/transactions; Dynamo for very large key-value scale.',
'[]',740,90),

('n_aws_dynamodb','DynamoDB (NoSQL)','DevOps & Cloud',
'DynamoDB là CSDL NoSQL (key-value / document) được quản lý HOÀN TOÀN, độ
trễ mili-giây ở MỌI quy mô, tự scale. Serverless (không quản server DB).

MÔ HÌNH:
  • Table -> item (dòng) -> attribute; mỗi item định danh bằng PRIMARY KEY:
    - Partition key (băm để phân tán dữ liệu), tùy chọn thêm Sort key.
  • Không schema cứng (mỗi item có thể có thuộc tính khác nhau).
  • Truy vấn hiệu quả theo KEY; muốn query linh hoạt hơn cần index phụ (GSI).

ĐẶC ĐIỂM:
  • Hiệu năng ổn định ở quy mô cực lớn (triệu request/giây).
  • On-demand (trả theo request) hoặc provisioned capacity.
  • Tích hợp tốt với serverless (Lambda + DynamoDB).

KHÁC RDS:
  Dynamo (NoSQL): scale khủng, truy vấn theo key, KHÔNG JOIN phức tạp ->
    phải thiết kế mô hình dữ liệu theo TRUY VẤN (access pattern).
  RDS (SQL): quan hệ, JOIN, giao dịch phức tạp, truy vấn linh hoạt.

DÙNG CHO: session, giỏ hàng, IoT, bảng xếp hạng, dữ liệu quy mô lớn truy
cập theo key.

MẸO: chọn Dynamo khi cần scale cực lớn + mẫu truy vấn rõ theo key; chọn RDS
khi cần quan hệ/JOIN/giao dịch. Thiết kế Dynamo xuất phát từ ACCESS PATTERN
(khác hẳn tư duy chuẩn hóa của SQL).',
'DynamoDB is a FULLY managed NoSQL database (key-value / document) with
millisecond latency at ANY scale, auto-scaling. Serverless (no DB servers to
manage).

MODEL:
  • Table -> item (row) -> attribute; each item identified by a PRIMARY KEY:
    - a Partition key (hashed to distribute data), optionally a Sort key.
  • No rigid schema (items can have different attributes).
  • Efficient queries BY KEY; for more flexible queries you need secondary
    indexes (GSI).

CHARACTERISTICS:
  • Stable performance at enormous scale (millions of requests/second).
  • On-demand (pay per request) or provisioned capacity.
  • Integrates well with serverless (Lambda + DynamoDB).

VS RDS:
  Dynamo (NoSQL): massive scale, key-based queries, NO complex JOINs -> you
    must model data around the QUERIES (access patterns).
  RDS (SQL): relational, JOINs, complex transactions, flexible queries.

USED FOR: sessions, shopping carts, IoT, leaderboards, large-scale data
accessed by key.

TIP: choose Dynamo for very large scale + clear key-based access; choose RDS
for relations/JOINs/transactions. Dynamo design starts from ACCESS PATTERNS
(quite unlike SQL normalization thinking).',
'[]',700,110),

('n_aws_cache','ElastiCache (Redis)','DevOps & Cloud',
'ElastiCache là dịch vụ CACHE trong bộ nhớ được quản lý (Redis hoặc
Memcached) -> tăng tốc đọc, giảm tải DB.

VÌ SAO CACHE:
  Đọc DB tốn kém/lặp lại -> lưu kết quả trong RAM (Redis) -> lần sau trả
  trong micro/mili-giây.
  App -> (kiểm tra cache) -> hit? trả ngay : miss? query DB rồi lưu vào cache

REDIS vs MEMCACHED:
  • Redis: giàu tính năng (cấu trúc dữ liệu, pub/sub, persistence,
    replication, sorted set) -> phổ biến hơn.
  • Memcached: đơn giản, đa luồng, chỉ cache key-value thuần.

MẪU DÙNG:
  • Cache-aside: app tự kiểm tra cache trước, miss thì nạp từ DB rồi ghi cache.
  • Session store, rate limiting, leaderboard (Redis sorted set), hàng đợi nhẹ.

LƯU Ý: cache có thể CŨ (stale) -> đặt TTL + chiến lược vô hiệu hóa
(invalidation) khi dữ liệu đổi. Có câu đùa: "hai việc khó nhất là vô hiệu
cache và đặt tên biến".

MẸO: cache những thứ đọc-nhiều-ghi-ít (config, hồ sơ, kết quả tính nặng),
đặt TTL hợp lý. Redis là lựa chọn mặc định. Đây là cách rẻ & hiệu quả để
giảm tải RDS/DynamoDB và tăng tốc app.',
'ElastiCache is a managed in-memory CACHE service (Redis or Memcached) ->
faster reads, less DB load.

WHY CACHE:
  Expensive/repeated DB reads -> store the result in RAM (Redis) -> next time
  served in micro/milliseconds.
  App -> (check cache) -> hit? return now : miss? query DB then store in cache

REDIS vs MEMCACHED:
  • Redis: feature-rich (data structures, pub/sub, persistence, replication,
    sorted sets) -> more popular.
  • Memcached: simple, multi-threaded, plain key-value cache only.

USAGE PATTERNS:
  • Cache-aside: the app checks cache first, on a miss loads from DB and writes cache.
  • Session store, rate limiting, leaderboards (Redis sorted sets), light queues.

NOTE: caches can be STALE -> set a TTL + an invalidation strategy when data
changes. As the joke goes: "the two hardest things are cache invalidation and
naming things".

TIP: cache read-heavy, write-light things (config, profiles, heavy computed
results), with a sensible TTL. Redis is the default choice. This is a cheap,
effective way to offload RDS/DynamoDB and speed up the app.',
'[]',740,130),

-- ------------------------- OPS ------------------------------------
('n_aws_cloudfront','CloudFront (CDN)','DevOps & Cloud',
'CloudFront là CDN của AWS: phân phối nội dung từ edge location gần người
dùng (xem thêm node CDN chung ở topic Network). Tích hợp chặt với S3, ALB,
EC2 làm origin.

CÁCH DÙNG:
  Origin (S3 / ALB / EC2) -> CloudFront (cache ở hàng trăm edge) -> User
  • Cache asset tĩnh (ảnh, JS, CSS, video) gần user -> nhanh, giảm tải origin.
  • Hỗ trợ HTTPS (cert qua ACM miễn phí), HTTP/2, HTTP/3.
  • Cache behavior theo path (vd /static/* cache lâu, /api/* không cache).

TÍNH NĂNG:
  • Chống DDoS (kèm AWS Shield), WAF (lọc tấn công tầng 7).
  • Lambda@Edge / CloudFront Functions: chạy code ngay ở edge (rewrite, auth nhẹ).
  • Signed URL/cookie: giới hạn truy cập nội dung riêng tư.

MẪU KINH ĐIỂN: web tĩnh (React build) trên S3 + CloudFront -> nhanh, rẻ,
HTTPS, scale sẵn.

MẸO: đặt CloudFront trước S3 cho asset tĩnh và trước ALB cho web động ->
tăng tốc toàn cầu + giảm tải origin + thêm lớp bảo mật (Shield/WAF). Dùng
ACM để có chứng chỉ HTTPS miễn phí.',
'CloudFront is the AWS CDN: it delivers content from edge locations near users
(see the general CDN node in the Network topic). Integrates tightly with S3,
ALB, EC2 as origins.

HOW TO USE:
  Origin (S3 / ALB / EC2) -> CloudFront (cached at hundreds of edges) -> User
  • Cache static assets (images, JS, CSS, video) near users -> fast, offloads origin.
  • Supports HTTPS (free cert via ACM), HTTP/2, HTTP/3.
  • Cache behavior per path (e.g. /static/* cached long, /api/* not cached).

FEATURES:
  • DDoS protection (with AWS Shield), WAF (layer-7 attack filtering).
  • Lambda@Edge / CloudFront Functions: run code at the edge (rewrites, light auth).
  • Signed URLs/cookies: restrict access to private content.

CLASSIC PATTERN: a static site (React build) on S3 + CloudFront -> fast,
cheap, HTTPS, already scalable.

TIP: put CloudFront in front of S3 for static assets and in front of an ALB
for dynamic web -> global speedup + origin offload + a security layer
(Shield/WAF). Use ACM for a free HTTPS certificate.',
'[]',940,50),

('n_aws_route53','Route 53 (DNS)','DevOps & Cloud',
'Route 53 là dịch vụ DNS được quản lý của AWS (xem node DNS chung ở topic
Network), cộng thêm đăng ký domain và định tuyến thông minh + health check.

CHỨC NĂNG:
  • Hosted zone: quản lý bản ghi DNS cho domain (A, AAAA, CNAME, MX, TXT...).
  • Đăng ký / chuyển domain.
  • Alias record: trỏ domain gốc (example.com) tới tài nguyên AWS (ALB,
    CloudFront, S3) — miễn phí, tự cập nhật IP (khác CNAME thường, dùng được
    ở apex domain).

ROUTING POLICY (định tuyến thông minh):
  • Simple        : một bản ghi.
  • Weighted      : chia % lưu lượng (A/B testing, canary).
  • Latency-based : gửi user tới region GẦN nhất -> nhanh.
  • Failover      : kèm health check, tự chuyển sang site dự phòng khi site
    chính chết.
  • Geolocation   : theo vị trí địa lý của user.

MẸO: dùng Alias record (KHÔNG phải CNAME) để trỏ apex domain vào ALB/
CloudFront. Latency-based + health check + failover = định tuyến toàn cầu
HA. Route 53 + CloudFront + ALB là bộ khung phân phối chuẩn trên AWS.',
'Route 53 is the AWS managed DNS service (see the general DNS node in the
Network topic), plus domain registration and smart routing + health checks.

FEATURES:
  • Hosted zone: manages DNS records for a domain (A, AAAA, CNAME, MX, TXT...).
  • Domain registration / transfer.
  • Alias record: points an apex domain (example.com) to an AWS resource (ALB,
    CloudFront, S3) — free, auto-updates IPs (unlike a plain CNAME, and works
    at the apex domain).

ROUTING POLICIES (smart routing):
  • Simple        : a single record.
  • Weighted      : split traffic by % (A/B testing, canary).
  • Latency-based : send users to the NEAREST region -> faster.
  • Failover      : with health checks, auto-switch to a backup site when the
    primary dies.
  • Geolocation   : by the user geographic location.

TIP: use an Alias record (NOT a CNAME) to point an apex domain to an ALB/
CloudFront. Latency-based + health checks + failover = global HA routing.
Route 53 + CloudFront + ALB is the standard AWS delivery stack.',
'[]',980,90),

('n_aws_cloudwatch','CloudWatch (Giám sát)','DevOps & Cloud',
'CloudWatch là hệ GIÁM SÁT & QUAN SÁT (observability) của AWS: thu thập
metric, log, và cảnh báo cho hầu hết mọi dịch vụ.

BA PHẦN:
  • Metrics: số đo theo thời gian (CPU của EC2, số invocation Lambda, độ trễ
    ALB, kết nối RDS). Có sẵn cho hầu hết dịch vụ.
  • Logs   : gom log tập trung (CloudWatch Logs); app/Lambda đẩy log vào để
    tìm kiếm.
  • Alarms : đặt ngưỡng -> vượt thì báo (qua SNS -> email/Slack) hoặc kích
    hoạt auto-scaling.

CÔNG CỤ LIÊN QUAN:
  • Dashboards: bảng biểu đồ tổng hợp.
  • Alarm + ASG: CPU > 70% -> tự thêm EC2.
  • X-Ray: distributed tracing (lần theo request qua nhiều dịch vụ).
  • CloudTrail (KHÁC): ghi lại AI GỌI API gì (audit/bảo mật), không phải metric.

MẸO: đặt alarm cho các chỉ số sống còn (CPU, tỉ lệ lỗi 5xx, độ trễ, độ dài
hàng đợi) -> phát hiện sự cố sớm + tự động scale. Đẩy log ứng dụng vào
CloudWatch Logs để tra cứu. Phân biệt: CloudWatch = hiệu năng/log; CloudTrail
= nhật ký hành động API (audit).',
'CloudWatch is the AWS MONITORING & observability system: it collects metrics,
logs, and alerts for almost every service.

THREE PARTS:
  • Metrics: time-series measurements (EC2 CPU, Lambda invocations, ALB
    latency, RDS connections). Built in for most services.
  • Logs   : centralized log collection (CloudWatch Logs); apps/Lambda push
    logs in for searching.
  • Alarms : set a threshold -> alert on breach (via SNS -> email/Slack) or
    trigger auto-scaling.

RELATED TOOLS:
  • Dashboards: aggregated charts.
  • Alarm + ASG: CPU > 70% -> auto-add EC2.
  • X-Ray: distributed tracing (follow a request across services).
  • CloudTrail (DIFFERENT): records WHO CALLED which API (audit/security),
    not metrics.

TIP: set alarms on vital signals (CPU, 5xx error rate, latency, queue depth)
-> detect issues early + auto-scale. Push app logs into CloudWatch Logs for
lookups. Distinguish: CloudWatch = performance/logs; CloudTrail = an API
action audit log.',
'[]',1020,110),

('n_aws_messaging','SQS & SNS (Nhắn tin)','DevOps & Cloud',
'SQS và SNS là dịch vụ NHẮN TIN được quản lý, giúp TÁCH RỜI (decouple) các
thành phần -> chịu lỗi & co giãn tốt (nền của kiến trúc hướng sự kiện).

SQS (Simple Queue Service) — HÀNG ĐỢI (điểm-điểm):
  Producer -> [SQS queue] -> Consumer (kéo message về xử lý)
  • Message được GIỮ tới khi xử lý xong (at-least-once); consumer chậm/chết
    không làm mất việc.
  • Đệm tải đột biến (buffer): nhét vào queue, consumer xử lý theo nhịp của nó.
  • FIFO queue nếu cần đúng thứ tự + không trùng.

SNS (Simple Notification Service) — PUB/SUB (phát tán):
  Publisher -> [SNS topic] -> NHIỀU subscriber (SQS, Lambda, email, HTTP)
  • Một message -> nhiều nơi nhận cùng lúc (fan-out).

MẪU FAN-OUT KINH ĐIỂN: SNS topic -> nhiều SQS queue -> mỗi service xử lý độc lập.
KHÁC: EventBridge (bus sự kiện định tuyến theo luật), Kinesis (luồng dữ liệu
lớn/streaming).

MẸO: dùng SQS để đệm & xử lý NỀN (gửi email, xử lý ảnh) -> API trả nhanh,
worker xử lý sau. Dùng SNS khi một sự kiện cần nhiều nơi phản ứng. Đây là
cách "decouple" service giống message broker trong microservices.',
'SQS and SNS are managed MESSAGING services that DECOUPLE components -> better
fault tolerance & elasticity (the basis of event-driven architecture).

SQS (Simple Queue Service) - a QUEUE (point-to-point):
  Producer -> [SQS queue] -> Consumer (pulls messages to process)
  • Messages are KEPT until processed (at-least-once); a slow/dead consumer
    does not lose work.
  • Buffers load spikes: push into the queue, the consumer processes at its pace.
  • FIFO queue if you need strict order + no duplicates.

SNS (Simple Notification Service) - PUB/SUB (fan-out):
  Publisher -> [SNS topic] -> MANY subscribers (SQS, Lambda, email, HTTP)
  • One message -> received by many places at once (fan-out).

CLASSIC FAN-OUT PATTERN: an SNS topic -> multiple SQS queues -> each service
processes independently.
OTHERS: EventBridge (an event bus routing by rules), Kinesis (large-scale data
streaming).

TIP: use SQS to buffer & process in the BACKGROUND (send email, process
images) -> the API responds fast, workers handle it later. Use SNS when one
event needs many reactions. This "decouples" services like a message broker
in microservices.',
'[]',1060,90)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ===== seed_aws_edges =====
-- TOPIC AWS: edges
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_aws','root','t_aws','part-of'),
('e_t_aws_s_core','t_aws','s_aws_core','part-of'),
('e_t_aws_s_compute','t_aws','s_aws_compute','part-of'),
('e_t_aws_s_data','t_aws','s_aws_data','part-of'),
('e_t_aws_s_ops','t_aws','s_aws_ops','part-of'),
-- core
('e_s_aws_core_global','s_aws_core','n_aws_global','part-of'),
('e_s_aws_core_iam','s_aws_core','n_aws_iam','part-of'),
('e_s_aws_core_vpc','s_aws_core','n_aws_vpc','part-of'),
-- compute
('e_s_aws_compute_ec2','s_aws_compute','n_aws_ec2','part-of'),
('e_s_aws_compute_lambda','s_aws_compute','n_aws_lambda','part-of'),
('e_s_aws_compute_containers','s_aws_compute','n_aws_containers','part-of'),
('e_s_aws_compute_scaling','s_aws_compute','n_aws_scaling','part-of'),
-- data
('e_s_aws_data_s3','s_aws_data','n_aws_s3','part-of'),
('e_s_aws_data_rds','s_aws_data','n_aws_rds','part-of'),
('e_s_aws_data_dynamodb','s_aws_data','n_aws_dynamodb','part-of'),
('e_s_aws_data_cache','s_aws_data','n_aws_cache','part-of'),
-- ops
('e_s_aws_ops_cloudfront','s_aws_ops','n_aws_cloudfront','part-of'),
('e_s_aws_ops_route53','s_aws_ops','n_aws_route53','part-of'),
('e_s_aws_ops_cloudwatch','s_aws_ops','n_aws_cloudwatch','part-of'),
('e_s_aws_ops_messaging','s_aws_ops','n_aws_messaging','part-of'),
-- related (nội bộ AWS)
('e_aws_ec2_scaling','n_aws_ec2','n_aws_scaling','related'),
('e_aws_ec2_containers','n_aws_ec2','n_aws_containers','related'),
('e_aws_lambda_dynamodb','n_aws_lambda','n_aws_dynamodb','related'),
('e_aws_s3_cloudfront','n_aws_s3','n_aws_cloudfront','related'),
('e_aws_rds_dynamodb','n_aws_rds','n_aws_dynamodb','related'),
('e_aws_vpc_scaling','n_aws_vpc','n_aws_scaling','related'),
('e_aws_cloudwatch_scaling','n_aws_cloudwatch','n_aws_scaling','related'),
('e_aws_route53_cloudfront','n_aws_route53','n_aws_cloudfront','related'),
('e_aws_iam_ec2','n_aws_iam','n_aws_ec2','related'),
-- related (liên topic)
('e_aws_containers_docker','n_aws_containers','t_docker','related'),
('e_aws_cloudfront_cdn','n_aws_cloudfront','n_net_cdn','related'),
('e_aws_route53_dns','n_aws_route53','n_net_dns','related'),
('e_aws_vpc_natfw','n_aws_vpc','n_net_nat_fw','related'),
('e_aws_scaling_lb','n_aws_scaling','n_net_lb','related'),
('e_aws_rds_mysql','n_aws_rds','t_mysql','related'),
('e_aws_messaging_ms','n_aws_messaging','n_ms_async','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);
