/**
 * Cloudflare Wrangler OAuth helper.
 * Binds IPv4 127.0.0.1 so the callback is reachable, then writes wrangler config.
 */
const http = require('http');
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const { URL } = require('url');
const { exec } = require('child_process');

const CLIENT_ID = '54d11594-84e4-41aa-b438-e81b8fa78ee7';
const REDIRECT = 'http://localhost:8976/oauth/callback';
const AUTH = 'https://dash.cloudflare.com/oauth2/auth';
const TOKEN = 'https://dash.cloudflare.com/oauth2/token';
const SCOPES = [
  'account:read', 'user:read', 'workers:write', 'workers_kv:write',
  'workers_routes:write', 'workers_scripts:write', 'workers_tail:read',
  'd1:write', 'pages:write', 'zone:read', 'ssl_certs:write', 'offline_access',
].join(' ');

function b64url(buf) {
  return Buffer.from(buf).toString('base64url');
}

function configPath() {
  const base = process.env.XDG_CONFIG_HOME
    || path.join(process.env.APPDATA || '', 'xdg.config');
  return path.join(base, '.wrangler', 'config', 'default.toml');
}

async function main() {
  const verifier = b64url(crypto.randomBytes(32));
  const challenge = b64url(crypto.createHash('sha256').update(verifier).digest());
  const state = b64url(crypto.randomBytes(16));

  const authUrl = new URL(AUTH);
  authUrl.searchParams.set('response_type', 'code');
  authUrl.searchParams.set('client_id', CLIENT_ID);
  authUrl.searchParams.set('redirect_uri', REDIRECT);
  authUrl.searchParams.set('scope', SCOPES);
  authUrl.searchParams.set('state', state);
  authUrl.searchParams.set('code_challenge', challenge);
  authUrl.searchParams.set('code_challenge_method', 'S256');

  const urlText = authUrl.toString();
  fs.writeFileSync(path.join(__dirname, '..', 'oauth_url.txt'), urlText);
  console.log('AUTH_URL=' + urlText);

  const code = await new Promise((resolve, reject) => {
    const server = http.createServer(async (req, res) => {
      try {
        const u = new URL(req.url, 'http://127.0.0.1:8976');
        if (u.pathname !== '/oauth/callback') {
          res.writeHead(404);
          res.end('not found');
          return;
        }
        if (u.searchParams.get('state') !== state) {
          res.writeHead(400);
          res.end('bad state');
          return;
        }
        const authCode = u.searchParams.get('code');
        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.end('<html><body><h2>Cloudflare login OK. You can close this tab.</h2></body></html>');
        server.close();
        resolve(authCode);
      } catch (err) {
        reject(err);
      }
    });
    server.listen(8976, '127.0.0.1', () => {
      console.log('Listening on http://127.0.0.1:8976');
      // Open system browser as fallback
      const openCmd = process.platform === 'win32'
        ? `cmd /c start "" "${urlText.replace(/&/g, '^&')}"`
        : `xdg-open "${urlText}"`;
      exec(openCmd, () => {});
    });
    setTimeout(() => reject(new Error('timeout waiting for oauth callback')), 180000);
  });

  console.log('Got authorization code, exchanging…');
  const body = new URLSearchParams({
    grant_type: 'authorization_code',
    client_id: CLIENT_ID,
    code_verifier: verifier,
    code,
    redirect_uri: REDIRECT,
  });

  const tokenRes = await fetch(TOKEN, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body,
  });
  const tokenJson = await tokenRes.json();
  if (!tokenRes.ok) {
    console.error(tokenJson);
    process.exit(1);
  }

  const out = configPath();
  fs.mkdirSync(path.dirname(out), { recursive: true });
  const toml = [
    `oauth_token = "${tokenJson.access_token}"`,
    tokenJson.refresh_token ? `refresh_token = "${tokenJson.refresh_token}"` : '',
    tokenJson.expires_in ? `expiration_time = ${Date.now() + tokenJson.expires_in * 1000}` : '',
    'scopes = [',
    ...SCOPES.split(' ').map((s) => `  "${s}",`),
    ']',
  ].filter(Boolean).join('\n') + '\n';

  fs.writeFileSync(out, toml);
  console.log('Wrote ' + out);
  console.log('LOGIN_OK');
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
