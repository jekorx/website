# pnpm

### 设置淘宝镜像源

```bash
# 查询当前使用的镜像源
pnpm get registry

# 设置为淘宝镜像源
pnpm config set registry https://registry.npmmirror.com/

# 还原为官方镜像源
pnpm config set registry https://registry.npmjs.org/

# 解决node-sass安装失败的问题
pnpm config set sass_binary_site https://registry.npmmirror.com/node-sass/
```
