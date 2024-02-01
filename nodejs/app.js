const finalhandler = require('finalhandler');
const fs = require('fs');
const http = require('http');
const serveStatic = require('serve-static');

const PATH = process.env.ISO_PATH || '.';
const HOST = process.env.HOST || '0.0.0.0';
const PORT = process.env.PORT || 8300;

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

function handleListing(rewrites, response) {
    response.setHeader('Content-Type', 'text/plain');
    response.writeHead(200);
    response.end('/\n' + rewrites.map(rewrite => rewrite.source).join('\n'));
}

function flattenDirToRewrites(dirPath, subdir = '/', list = []) {
    const files = fs.readdirSync(dirPath);

    return files.reduce((list, file) => {
        const path = dirPath + '/' + file;
        if (fs.statSync(path).isDirectory()) {
            return flattenDirToRewrites(path, subdir + file + '/', list);
        }

        if (/\.(chd|cso|elf|iso|pbp|ppdmp|prx)$/i.test(file)) {
            list.push({
                source: '/' + encodeURIComponent(file),
                destination: subdir + encodeURIComponent(file)
            });
        }
        return list;
    }, list);
}
