package light.mvc.utils;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.LinkedList;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import java.util.Set;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;

public class ExcelExportUtil {
	public static HSSFWorkbook generateExcel(LinkedList<Map<String, String>> list, String title) {
		HSSFWorkbook book = new HSSFWorkbook();
		try {
			HSSFSheet sheet = book.createSheet(title);
			sheet.autoSizeColumn(1, true);// 自适应列宽度
			// 样式设置
			HSSFCellStyle style = book.createCellStyle();
			style.setFillForegroundColor(HSSFColor.WHITE.index);
//			style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			style.setBorderRight(HSSFCellStyle.BORDER_THIN);
			style.setBorderTop(HSSFCellStyle.BORDER_THIN);
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			// 生成一个字体
			HSSFFont font = book.createFont();
			font.setColor(HSSFColor.BLACK.index);
			font.setFontHeightInPoints((short) 12);
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			// 把字体应用到当前的样式
			style.setFont(font);
			
			// 设置标题格式
			HSSFCellStyle style2 = book.createCellStyle();
			style2.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			// 设置上下左右边框
			style2.setFillForegroundColor(HSSFColor.GREY_80_PERCENT.index);
			style2.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			style2.setBorderRight(HSSFCellStyle.BORDER_THIN);
			style2.setBorderTop(HSSFCellStyle.BORDER_THIN);
			style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style2.setFillForegroundColor(HSSFColor.BLUE_GREY.index);
			// 表头生成一个字体
			HSSFFont font1 = book.createFont();
			font1.setColor(HSSFColor.WHITE.index);
			font1.setFontHeightInPoints((short) 10);
			font1.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			style2.setFont(font1);
			
			// 设置内容格式
			HSSFCellStyle style3 = book.createCellStyle();
			style3.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			// 设置上下左右边框
			style3.setFillForegroundColor(HSSFColor.WHITE.index);
			style3.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			style3.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			style3.setBorderRight(HSSFCellStyle.BORDER_THIN);
			style3.setBorderTop(HSSFCellStyle.BORDER_THIN);
			style3.setAlignment(HSSFCellStyle.ALIGN_CENTER);

			// 填充表头标题
			int colSize = list.get(0).entrySet().size();
			System.out.println("size:" + colSize);
			// 合并单元格供标题使用(表名)
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, colSize - 1));
			HSSFRow firstRow = sheet.createRow(0);// 第几行（从0开始）
			HSSFCell firstCell = firstRow.createCell(0);
			firstCell.setCellValue(title);
			firstCell.setCellStyle(style);

			// 填充表头header
			HSSFRow row = sheet.createRow(1);
			Set<Entry<String, String>> set = list.get(0).entrySet();
			LinkedList<Entry<String, String>> l = new LinkedList<Map.Entry<String, String>>(set);
			System.out.println("l:" + l.size());
			for (int i = 0; i < l.size(); i++) {
				String key = l.get(i).getKey();
				System.out.println(key);
				HSSFCell cell = row.createCell(i);
				cell.setCellValue(key);
				cell.setCellStyle(style2);
			}

			// 填充表格内容
			System.out.println("list:" + list.size());
			for (int i = 0; i < list.size(); i++) {
				HSSFRow row2 = sheet.createRow(i + 2);// index：第几行
				Map<String, String> map = list.get(i);
				Set<Entry<String, String>> set2 = map.entrySet();
				LinkedList<Entry<String, String>> ll = new LinkedList(set2);
				for (int j = 0; j < ll.size(); j++) {
					String val = ll.get(j).getValue();
					HSSFCell cell = row2.createCell(j);// 第几列：从0开始
					cell.setCellValue(val);
					cell.setCellStyle(style3);
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return book;
	}
	
	public static void createStream(HttpServletResponse response, String fileName, ByteArrayOutputStream os)
			throws UnsupportedEncodingException, IOException {
		byte[] content = os.toByteArray();
		InputStream is = new ByteArrayInputStream(content);
		// 设置response参数，可以打开下载页面
		response.reset();
		response.setContentType("application/vnd.ms-excel;charset=utf-8");
		response.setHeader("Content-Disposition",
				"attachment;filename=" + new String((fileName + ".xls").getBytes(), "iso-8859-1"));
		ServletOutputStream out = response.getOutputStream();
		BufferedInputStream bis = null;
		BufferedOutputStream bos = null;
		try {
			bis = new BufferedInputStream(is);
			bos = new BufferedOutputStream(out);
			byte[] buff = new byte[2048];
			int bytesRead;
			// Simple read/write loop.
			while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
				bos.write(buff, 0, bytesRead);
			}
		} catch (final IOException e) {
			throw e;
		} finally {
			if (bis != null)
				bis.close();
			if (bos != null)
				bos.close();
		}
	}
}
