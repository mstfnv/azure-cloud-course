const http = require('http');
const port = process.env.PORT || 8080;
http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Hello from Azure App Service — deployed by MS!\n');
}).listen(port, () => console.log(`Running on port ${port}`));