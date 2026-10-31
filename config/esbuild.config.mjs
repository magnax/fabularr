import * as esbuild from "esbuild";

const options = {
  entryPoints: {
    "application-bundled": "app/javascript/application-esbuild.ts",
    "admin-bundled": "app/javascript/admin-esbuild.ts",
  },
  bundle: true,
  sourcemap: true,
  outdir: "app/assets/builds",
};

if (process.argv.includes("--watch")) {
  const ctx = await esbuild.context(options);
  await ctx.watch();
} else {
  await esbuild.build(options);
}
