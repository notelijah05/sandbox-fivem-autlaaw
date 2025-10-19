const { defineConfig } = require('vite');
const react = require('@vitejs/plugin-react');
const legacy = require('@vitejs/plugin-legacy').default;
const path = require('path');

module.exports = defineConfig(({ mode }) => {
  // Use relative paths in production so NUI (CEF) can load assets from file://
  const base = mode === 'production' ? './' : '/';
  return {
    base,
    plugins: [
      react(),
      legacy({
        // Target a conservative baseline for CEF in FiveM
        targets: ['chrome >= 58'],
        additionalLegacyPolyfills: ['regenerator-runtime/runtime'],
        modernPolyfills: true,
      }),
    ],
    resolve: {
      alias: {
        containers: path.resolve(__dirname, 'src/containers'),
        components: path.resolve(__dirname, 'src/components'),
        util: path.resolve(__dirname, 'src/util'),
        assets: path.resolve(__dirname, 'src/assets'),
        src: path.resolve(__dirname, 'src'),
      },
    },
    build: {
      outDir: 'dist',
      sourcemap: false,
      target: 'es2017',
    },
    server: {
      port: 5173,
      open: false,
    },
  };
});
