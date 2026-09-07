/**
 * Static file server with gzip for Flutter web previews through Cloudflare Tunnel.
 * Usage: node tools/gzip_static_server.js [dir] [port]
 */
const http = require('http');
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');
const { pipeline } = require('stream');

const root = path.resolve(process.argv[2] || 'build/web');
const port = Number(process.argv[3] || 8790);

const types = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.mjs': 'application/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.wasm': 'application/wasm',
  '.ttf': 'font/ttf',
  '.otf': 'font/otf',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.txt': 'text/plain; charset=utf-8',
  '.map': 'application/json',
};

function safeJoin(base, requestPath) {
  const decoded = decodeURIComponent(requestPath.split('?')[0]);
  const cleaned = path.normalize(decoded).replace(/^([/\\])+/, '');
  const full = path.join(base, cleaned);
  if (!full.startsWith(base)) return null;
  return full;
}

const server = http.createServer((req, res) => {
  let filePath = safeJoin(root, req.url === '/' ? '/index.html' : req.url);
  if (!filePath) {
    res.writeHead(400);
    res.end('Bad request');
    return;
  }

  fs.stat(filePath, (err, stat) => {
    if (err || !stat.isFile()) {
      // SPA fallback
      filePath = path.join(root, 'index.html');
    }

    const ext = path.extname(filePath).toLowerCase();
    const type = types[ext] || 'application/octet-stream';
    const accept = req.headers['accept-encoding'] || '';
    const useGzip = accept.includes('gzip') && ['.js', '.css', '.html', '.json', '.svg', '.wasm', '.map'].includes(ext);

    const headers = {
      'Content-Type': type,
      'Cache-Control': ext === '.html' ? 'no-cache' : 'public, max-age=3600',
      'Access-Control-Allow-Origin': '*',
    };

    const stream = fs.createReadStream(filePath);
    stream.on('error', () => {
      res.writeHead(404);
      res.end('Not found');
    });

    if (useGzip) {
      headers['Content-Encoding'] = 'gzip';
      headers['Vary'] = 'Accept-Encoding';
      res.writeHead(200, headers);
      pipeline(stream, zlib.createGzip({ level: 6 }), res, (pipelineErr) => {
        if (pipelineErr && !res.headersSent) {
          res.writeHead(500);
          res.end('Server error');
        }
      });
    } else {
      headers['Content-Length'] = String(stat.size);
      res.writeHead(200, headers);
      pipeline(stream, res, () => {});
    }
  });
});

server.listen(port, '127.0.0.1', () => {
  console.log(`Gzip static server listening on http://127.0.0.1:${port}`);
  console.log(`Serving ${root}`);
});
