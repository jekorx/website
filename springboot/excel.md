# Excel

> SpringBoot 使用 POI 生成并导出 Excel。  
> 以下为后端代码，前端代码[可参照](../frontend/chrome-download.md#excel下载)。  

```xml
<!-- POI 依赖 -->
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml</artifactId>
    <version>4.1.1</version>
</dependency>
```

###### 导出xlsx类型

```java
/**
  * 导出excel接口（xlsx类型）
  * @param response
  */
@GetMapping("/v1/export")
public void exportExcel(HttpServletResponse response) {
    // 测试数据
    List<User> list = new ArrayList<>();
    // id name age createTime
    list.add(new User(1, 'username 1', 18, new Date()));
    list.add(new User(2, 'username 2', 28, new Date()));
    list.add(new User(3, 'username 3', 16, new Date()));
    list.add(new User(4, 'username 4', 25, new Date()));

    // 创建文档（xlsx类型）
    SXSSFWorkbook workbook = new SXSSFWorkbook();
    // 创建sheet页
    SXSSFSheet sheet = workbook.createSheet("sheet 1");

    // 处理excel
    excelHandle(workbook, sheet, list);

    // 流输出
    OutputStream outputStream = null;
    try {
        // 设置响应内容类型
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8");
        // 此处导出名字可能为乱码，前后端分离下载不影响，前端生成文件名
        response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode("导出excel.xlsx", "UTF-8"));
        // 获取response的输出流
        outputStream = new BufferedOutputStream(response.getOutputStream());
        // 文档数据写入输出流
        workbook.write(outputStream);
        outputStream.flush();
    } catch (IOException ie) {
        // 包装异常并抛出
        throw new BusinessException(ResultEnums.FAILED.getCode(), "excel导出失败");
    } finally {
        if (null != outputStream) {
            try {
                outputStream.close();
            } catch (IOException ie) {
                throw new BusinessException(ResultEnums.FAILED.getCode(), "excel导出异常");
            }
        }
    }
}

/**
 * excel处理（xlsx类型）
 * @param workbook excel文档
 * @param sheet sheet页
 * @param list 数据
 */
private void excelHandle(SXSSFWorkbook workbook, SXSSFSheet sheet, List<User> list) {
    // 设置默认行高
    sheet.setDefaultRowHeightInPoints(20);
    // 设置列宽，第一个参数为索引，第二个参数为列宽，列宽单位为一个字符宽度的 1/256，列宽需要乘以 256
    sheet.setColumnWidth(1, 12 * 256);
    sheet.setColumnWidth(2, 15 * 256);
    sheet.setColumnWidth(4, 20 * 256);
    
    // 创建第一行
    SXSSFRow row = sheet.createRow(0);
    // 设置当前行高
    row.setHeightInPoints(20);
    //设置为居中加粗
    CellStyle style = workbook.createCellStyle();
    Font font = workbook.createFont();
    // 粗体
    font.setBold(true);
    // 设置居中
    style.setAlignment(HorizontalAlignment.CENTER);
    style.setVerticalAlignment(VerticalAlignment.CENTER);
    style.setFont(font);

    // 设置列
    SXSSFCell cell;
    cell = row.createCell(0);
    cell.setCellValue("序号");
    cell.setCellStyle(style);
    
    cell = row.createCell(1);
    cell.setCellValue("ID");
    cell.setCellStyle(style);
    
    cell = row.createCell(2);
    cell.setCellValue("姓名");
    cell.setCellStyle(style);
    
    cell = row.createCell(3);
    cell.setCellValue("年龄");
    cell.setCellStyle(style);
    
    cell = row.createCell(4);
    cell.setCellValue("注册时间");
    cell.setCellStyle(style);
    
    CellStyle cellStyle = workbook.createCellStyle();
    cellStyle.setAlignment(HorizontalAlignment.CENTER);
    cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);

    int rowNum = 1; // 0为表头，从1开始记序号
    for (User u : list) {
        SXSSFRow r = sheet.createRow(rowNum);
        r.setHeightInPoints(20);
    
        SXSSFCell c = r.createCell(0);
        c.setCellValue(rowNum);
        c.setCellStyle(cellStyle);
    
        c = r.createCell(1);
        c.setCellValue(u.getId());
        c.setCellStyle(cellStyle);
    
        c = r.createCell(2);
        c.setCellValue(u.getName());
        c.setCellStyle(cellStyle);
    
        c = r.createCell(3);
        c.setCellValue(u.getAge());
        c.setCellStyle(cellStyle);
    
        c = r.createCell(4);
        c.setCellValue(DateUtil.formatDateTime(u.getCreateTime());
        c.setCellStyle(cellStyle);
    
        rowNum++;
    }
}
```

###### 导出xls类型

```java
/**
  * 导出excel接口（xls类型）
  * @param response
  */
@GetMapping("/v1/export")
public void exportExcel(HttpServletResponse response) {
    // 测试数据
    List<User> list = new ArrayList<>();
    // id name age createTime
    list.add(new User(1, 'username 1', 18, new Date()));
    list.add(new User(2, 'username 2', 28, new Date()));
    list.add(new User(3, 'username 3', 16, new Date()));
    list.add(new User(4, 'username 4', 25, new Date()));

    // 创建文档（xls类型）
    HSSFWorkbook workbook = new HSSFWorkbook();
    // 创建sheet页
    HSSFSheet sheet = workbook.createSheet("sheet 1");

    // 处理excel
    excelHandle(workbook, sheet, list);

    // 流输出
    OutputStream outputStream = null;
    try {
        // 设置响应内容类型
        response.setContentType("application/vnd.ms-excel;charset=UTF-8");
        // 此处导出名字可能为乱码，前后端分离下载不影响，前端生成文件名
        response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode("导出excel.xls", "UTF-8"));
        // 获取response的输出流
        outputStream = response.getOutputStream();
        // 文档数据写入输出流
        workbook.write(outputStream);
        outputStream.flush();
    } catch (IOException ie) {
        // 包装异常并抛出
        throw new BusinessException(ResultEnums.FAILED.getCode(), "excel导出失败");
    } finally {
        if (null != outputStream) {
            try {
                outputStream.close();
            } catch (IOException ie) {
                throw new BusinessException(ResultEnums.FAILED.getCode(), "excel导出异常");
            }
        }
    }
}

/**
  * excel处理（xls类型）
  * @param workbook excel文档
  * @param sheet sheet页
  * @param list 数据
  */
private void excelHandle(HSSFWorkbook workbook, HSSFSheet sheet, List<User> list) {
    // 设置默认行高
    sheet.setDefaultRowHeightInPoints(20);
    // 设置列宽，第一个参数为索引，第二个参数为列宽，列宽单位为一个字符宽度的 1/256，列宽需要乘以 256
    sheet.setColumnWidth(1, 12 * 256);
    sheet.setColumnWidth(2, 15 * 256);
    sheet.setColumnWidth(4, 20 * 256);

    // 创建第一行
    HSSFRow row = sheet.createRow(0);
    // 设置当前行高
    row.setHeightInPoints(20);
    //设置为居中加粗
    HSSFCellStyle style = workbook.createCellStyle();
    HSSFFont font = workbook.createFont();
    // 粗体
    font.setBold(true);
    // 设置居中
    style.setAlignment(HorizontalAlignment.CENTER);
    style.setVerticalAlignment(VerticalAlignment.CENTER);
    style.setFont(font);

    // 设置列
    HSSFCell cell;
    cell = row.createCell(0);
    cell.setCellValue("序号");
    cell.setCellStyle(style);

    cell = row.createCell(1);
    cell.setCellValue("ID");
    cell.setCellStyle(style);

    cell = row.createCell(2);
    cell.setCellValue("姓名");
    cell.setCellStyle(style);

    cell = row.createCell(3);
    cell.setCellValue("年龄");
    cell.setCellStyle(style);

    cell = row.createCell(4);
    cell.setCellValue("注册时间");
    cell.setCellStyle(style);

    HSSFCellStyle cellStyle = workbook.createCellStyle();
    cellStyle.setAlignment(HorizontalAlignment.CENTER);
    cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);

    int rowNum = 1; // 0为表头，从1开始记序号
	for (User u : list) {
        HSSFRow r = sheet.createRow(rowNum);
        r.setHeightInPoints(20);

        HSSFCell c = r.createCell(0);
        c.setCellValue(rowNum);
        c.setCellStyle(cellStyle);

        c = r.createCell(1);
        c.setCellValue(u.getId());
        c.setCellStyle(cellStyle);

        c = r.createCell(2);
        c.setCellValue(u.getName());
        c.setCellStyle(cellStyle);

        c = r.createCell(3);
        c.setCellValue(u.getAge());
        c.setCellStyle(cellStyle);

        c = r.createCell(4);
        c.setCellValue(DateUtil.formatDateTime(u.getCreateTime()));
        c.setCellStyle(cellStyle);

        rowNum++;
    }
}
```