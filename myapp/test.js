import http from 'http';
import { expect } from 'chai';

const options = {
  hostname: 'localhost',
  port: 3000,
  method: 'GET',
  path: '/',
};

describe('HTTP Server', () => {
  it('should return 200 OK', (done) => {
    const req = http.request(options, (res) => {
      expect(res.statusCode).to.equal(200);
      done();
    });
    req.on('error', (e) => {
      done(e);
    });
    req.end();
  });

  it('should return "Hello, World!"', (done) => {
    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => {
        data += chunk;
      });
      res.on('end', () => {
        expect(data).to.equal('Hello, World!\n');
        done();
      });
    });
    req.on('error', (e) => {
      done(e);
    });
    req.end();
  });
});
