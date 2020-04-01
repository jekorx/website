# Chrome浏览器文件下载

#### 图片下载

```js
/**
 * src 图片链接
 * filename 下载图片命名
 * ext 图片格式，png jpg
 */
function downloadImg (src, filename, ext) {
  const img = new Image()
  const canvas = document.createElement('canvas')
  const ctx = canvas.getContext('2d')
  const link = document.createElement('a')
  img.setAttribute('crossOrigin', 'anonymous') // 设置允许跨域访问
  img.src = src
  img.onload = () => {
    canvas.width = img.width
    canvas.height = img.height
    ctx.drawImage(img, 0, 0, img.width, img.height)
    link.setAttribute('href', canvas.toDataURL('image/' + ext))
    link.setAttribute('target', '_blank')
    link.setAttribute('download', filename + '.' + ext)
    link.click()
  }
}
```

#### Excel下载

> 后端通过输出流导出Excel，前端下载文件，[后端代码请点击此处参照](../springboot/excel.md)。  

```javascript
// 以 axios 为例，需要设置响应参数类型为 blob
axios.get(`/v1/export`, {
  responseType: 'blob'
}).then(res => {
  if (res.status === 200) {
    let url = window.URL.createObjectURL(new Blob([res.data]))
    let link = document.createElement('a')
    link.href = url
    link.setAttribute('download', '导出excel.xls')
    link.click()
  }
})
```