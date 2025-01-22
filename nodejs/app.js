const finalhandler = require("finalhandler");
const fs = require("fs");
const http = require("http");
const serveStatic = require("serve-static");

const internalIsoPath = "/var/isos/";
const serverPort = 8300;

const serve = serveStatic(internalIsoPath, { fallthrough: false });

function handleListing(rewrites, res) {
    res.setHeader("Content-Type", "text/plain");
    res.writeHead(200).end("/\n" + rewrites.map((rewrite) => rewrite.destination).join("\n"));
}

function flattenDirToRewrites(dirPath, subdir = "/", list = []) {
    const files = fs.readdirSync(dirPath);

    return files.reduce((list, file) => {
        const path = dirPath + "/" + file;
        if (fs.statSync(path).isDirectory()) {
            return flattenDirToRewrites(path, subdir + file + "/", list);
        }
        if (/\.(chd|cso|elf|iso|pbp|ppdmp|prx)$/i.test(file)) {
            list.push({
                source: "/" + encodeURIComponent(file),
                destination: subdir + encodeURIComponent(file),
            });
        }
        return list;
    }, list);
}

const server = http.createServer((req, res) => {
    let rewrites = flattenDirToRewrites(internalIsoPath);
    if (/^\/($|\?)/.test(req.url)) return handleListing(rewrites, res);

    for (const rewrite of rewrites) {
        if (req.url === rewrite.source) {
            req.url = rewrite.destination;
            break;
        }
    }
    return serve(req, res, finalhandler(req, res));
});

server.listen(serverPort, () => {
    console.log(`Serving on port ${serverPort}`);
});
