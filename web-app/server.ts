import { readFileSync, existsSync } from 'fs';
import { join } from 'path';

const PORT = process.env.PORT || 3000;
const DIST_DIR = join(import.meta.dir, 'dist');

const mimeTypes: Record<string, string> = {
  '.html': 'text/html',
  '.js': 'application/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
};

function getMimeType(path: string): string {
  const ext = path.substring(path.lastIndexOf('.'));
  return mimeTypes[ext] || 'application/octet-stream';
}

const server = Bun.serve({
  port: PORT,
  fetch(req) {
    const url = new URL(req.url);
    let pathname = url.pathname;

    // Handle root and SPA routes
    if (pathname === '/' || !pathname.includes('.')) {
      pathname = '/index.html';
    }

    const filePath = join(DIST_DIR, pathname);

    if (existsSync(filePath)) {
      const file = readFileSync(filePath);
      const contentType = getMimeType(pathname);

      return new Response(file, {
        headers: {
          'Content-Type': contentType,
          'Cache-Control': pathname.includes('.') && !pathname.includes('index.html')
            ? 'public, max-age=31536000'
            : 'no-cache',
        },
      });
    }

    // For any 404s, serve index.html for SPA routing
    const indexPath = join(DIST_DIR, 'index.html');
    if (existsSync(indexPath)) {
      const file = readFileSync(indexPath);
      return new Response(file, {
        headers: {
          'Content-Type': 'text/html',
          'Cache-Control': 'no-cache',
        },
      });
    }

    return new Response('Not Found', { status: 404 });
  },
});

console.log(`Server running on http://localhost:${server.port}`);
