# JavaScript代码片段收藏

##### 1、同时生成条码二维码

![bar-qr-code](../assets/js-snippet-1.png)

> 使用```jsbarcode```生成条形码，```qrcode```生成二维码  
> 使用canvas合并生成的条形码、二维码  

```javascript
import JsBarCode from 'jsbarcode'
import QRCode from 'qrcode'
/**
 * 生成条码Promise，仅条形码可以生成内容
 */
const getBarCodePromise = code => {
  return new Promise((resolve, reject) => {
    try {
      const canvas = document.createElement('canvas')
      // 根据字符长度计算条码高度
      let h = code.length * 80
      if (h > 360) h = 360
      else if (h < 120) h = 120
      JsBarCode(canvas, code, {
        format: 'CODE39',
        text: `${code}`.split('').join(' '), // 条码内容增加空格间隔
        font: 'Microsoft YaHei',
        fontOptions: 'bold',
        fontSize: 120,
        width: 6, // 宽度是条码内容format之后的串的间隔，可参照文档或源码
        height: h, // 内容越长高度显得越小，可通过上面简单高度计算以及限制
        margin: 10
      })
      // 生成图片对象
      const img = new Image()
      img.setAttribute('crossOrigin', 'anonymous') // 设置允许跨域访问
      img.onload = () => {
        // 图片加载完之后resolve
        resolve(img)
      }
      img.src = canvas.toDataURL('image/png')
    } catch (error) {
      reject(error)
    }
  })
}
/**
 * 生成二维码Promise
 */
const getQrCodePromise = code => {
  return new Promise((resolve, reject) => {
    try {
      // 生成base64
      QRCode.toDataURL(code, {
        errorCorrectionLevel: 'H',
        version: 4,
        maskPattern: 7,
        margin: 1,
        width: 500
      }, (e, url) => {
        // 生成图片对象
        const img = new Image()
        img.setAttribute('crossOrigin', 'anonymous') // 设置允许跨域访问
        img.onload = () => {
          // 图片加载完之后resolve
          resolve(img)
        }
        img.src = url
      })
    } catch (error) {
      reject(error)
    }
  })
}
/**
 * 合并生成条码二维码图片并返回base64图片
 * @param {String} code
 * @return {String} base64
 */
export default code => {
  // 生成条码，并加载到Image对象中resolve
  const barCodePromise = getBarCodePromise(code)
  // 生成二维码，并加载到Image对象中resolve
  const qrCodePromise = getQrCodePromise(code)
  // 合并图片
  return new Promise((resolve, reject) => {
    Promise.allSettled([barCodePromise, qrCodePromise]).then(([{ value: barImg }, { value: qrImg }]) => {
      try {
        if (barImg && qrImg) {
          // 使用canvas合并图片
          const canvas = document.createElement('canvas')
          const ctx = canvas.getContext('2d')
          canvas.width = barImg.width
          canvas.height = barImg.height + barImg.width
          // 竖向排列条码、二维码
          ctx.drawImage(barImg, 0, 0, barImg.width, barImg.height)
          ctx.drawImage(qrImg, 0, barImg.height, barImg.width, barImg.width)
          // 生成图片url
          const url = canvas.toDataURL('image/png')
          // resolve合并后base64
          resolve(url)
        } else {
          reject(new Error(`生成二维码失败：${code}`))
        }
      } catch (error) {
        reject(error)
      }
    }).catch(reject)
  })
}
```

##### 2、批量下载图片

> 使用```jszip```批量下载图片zip文件  

```javascript
import ZIP from 'jszip'
import drawCode from './draw-code' // 1 中生成图片base64的方法

export default = codeArr => {
  // loading start
  const zip = new ZIP()
  const promises = codeArr.map(code => new Promise((resolve, reject) => {
    // 图片生成base64，此处使用 1 中方法，也可通过canvas的toDataURL将图片转为base64
    drawCode(code).then(url => {
      const [, data] = url.split(',')
      // zip.file第一个参数为key，不能重复
      zip.file(`条码二维码/${code}_条形码_二维码.png`, data, { base64: true })
      resolve()
    }).catch(reject)
  }))
  Promise.all(promises).then(() => {
    zip.generateAsync({ type: 'blob' }).then(data => {
      const url = window.URL.createObjectURL(data)
      const link = document.createElement('a')
      link.href = url
      link.setAttribute('download', '批量生成条码二维码.zip')
      link.click()
      // 回收URL
      window.URL.revokeObjectURL(url)
    })
  }).finally(() => {
    // loading end
  })
}
```

##### 3、导出Excel

> 使用```xlsx```导出excel  
> 并将数据每60000条切分，单独生成一个sheet页  
> ```splitArray```切分数组[可参照](./js-utils.md#切分数组) 

```javascript
/**
 * 导出Excel，不考虑切分sheet页
 */
export const exportExcel = (datas, name) => {
  if (!name) name = `${Date.now()}.xlsx`
  const wb = XLSX.utils.book_new()
  const sheets = Object.keys(datas)
  for (const s of sheets) {
    const ws = XLSX.utils.aoa_to_sheet(datas[s])
    XLSX.utils.book_append_sheet(wb, ws, s)
  }
  XLSX.writeFile(wb, name)
}
/**
 * 导出excel，超过60000条自动分sheet页
 * @param {*} data
 * @param {*} name
 */
export const exportData = (data, name) => {
  if (!name) name = `${Date.now()}.xlsx`
  const wb = XLSX.utils.book_new()
  const header = data[0]
  const arr = splitArray(data, 60000)
  for (let i = 0; i < arr.length; i++) {
    const d = arr[i]
    if (i > 0) {
      d.unshift(header)
    }
    const ws = XLSX.utils.aoa_to_sheet(d)
    XLSX.utils.book_append_sheet(wb, ws, `Sheet${i + 1}`)
  }
  XLSX.writeFile(wb, name)
}
```