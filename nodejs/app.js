const finalhandler = require('finalhandler');
const fs = require('fs');
const http = require('http');
const serveStatic = require('serve-static');

const PATH = process.env.ISO_PATH || '.';
const HOST = process.env.HOST || '0.0.0.0';
const PORT = process.env.PORT || 8300;

/**
 * @typedef {Object} Rewrite
 * @property {String} source Path used by PPSSPP.
 * @property {String} destination Path to actual file.
 */

const serve = serveStatic(PATH, {
    fallthrough: false,
});

const server = http.createServer((request, response) => {
    let rewrites = flattenDirToRewrites(PATH);

    if (/^\/($|\?)/.test(request.url)) {
        return handleListing(rewrites, response);
    }

    for (const rewrite of rewrites) {
        if (request.url === rewrite.source) {
            request.url = rewrite.destination;
            break;
        }
    }
    return serve(request, response, finalhandler(request, response));
});

server.listen(PORT, HOST, () => {
    console.log(`Running at http://${HOST}:${PORT}`);
});

/**
 * @param {Rewrite[]} rewrites List of supported files.
 * @param {http.ServerResponse} response HTTP response.
 */
function handleListing(rewrites, response) {
    response.setHeader('Content-Type', 'text/plain');
    response.writeHead(200);
    response.end('/\n' + rewrites.map(rewrite => rewrite.source).join('\n'));
}

/**
 * Read all files recursively in a folder, and extract playable files.
 * These are then mapped to rewrites for serve.
 * @param {String} dirPath Local path.
 * @param {String} subdir Public path so far.
 * @param {Rewrite[]} list Rewrites.
 * @returns {Rewrite[]} List of rewrites to any files.
 */
function flattenDirToRewrites(dirPath, subdir = '/', list = []) {
    const files = fs.readdirSync(dirPath);

    return files.reduce((list, file) => {
        const path = dirPath + '/' + file;
        if (fs.statSync(path).isDirectory()) {
            return flattenDirToRewrites(path, subdir + file + '/', list);
        }

        if (/\.(cso|iso|pbp|elf|prx|ppdmp)$/i.test(file)) {
            list.push({
                source: '/' + encodeURIComponent(file),
                destination: subdir + encodeURIComponent(file)
            });
        }
        return list;
    }, list);
}