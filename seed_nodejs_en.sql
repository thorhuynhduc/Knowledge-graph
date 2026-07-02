-- ===================================================================
--  BẢN DỊCH TIẾNG ANH cho các node Node.js Core (cột description_en)
--  Chạy SAU seed_nodejs_core.sql + seed_nodejs_advanced.sql.
--  Cần cột description_en (schema.sql đã có; DB cũ chạy ALTER:
--    ALTER TABLE kg_nodes ADD COLUMN description_en TEXT NULL;)
--  QUAN TRỌNG: dùng --default-character-set=utf8mb4 khi nạp.
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
