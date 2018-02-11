package light.mvc.utils;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import javax.naming.SizeLimitExceededException;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

/**
 * 
 * @author szl
 *
 */
public class UploadUtils {
	private static final String DOT = ".";

	private static final long MAX_FILE = 20 * 1024 * 1024;
	private static final long MAX_IMG = 3 * 1024 * 1024;

	/**
	 * 上传限制为20M
	 * 
	 * @param request
	 * @return
	 * 
	 * 		<pre>
	 * 使用方式
	 * MultipartFile file = multiRequest.getFile("file");获取文件
	 * InputStream input = file.getInputStream();获取文件流
	 * File source = new File(filePath);file.transferTo(source);保存文件到本地
	 * String name = multiRequest.getParameter("name");获取参数
	 *         </pre>
	 */
	public static MultipartHttpServletRequest createMultipartHttpServletRequest(HttpServletRequest request)
			throws MaxUploadSizeExceededException, SizeLimitExceededException {
		return createMultipartHttpServletRequest(request, MAX_FILE);
	}

	/**
	 * 图片上传限制为3M
	 * 
	 * @param request
	 * @return
	 * 
	 * 		<pre>
	 * 使用方式
	 * MultipartFile file = multiRequest.getFile("file");获取文件
	 * InputStream input = file.getInputStream();获取文件流
	 * File source = new File(filePath);file.transferTo(source);保存文件到本地
	 * String name = multiRequest.getParameter("name");获取参数
	 *         </pre>
	 */
	public static MultipartHttpServletRequest createMultipartHttpServletRequest2(HttpServletRequest request)
			throws MaxUploadSizeExceededException, SizeLimitExceededException {
		return createMultipartHttpServletRequest(request, MAX_IMG);
	}

	/**
	 * @param request
	 * @param maxSize
	 *            上次限制大小 单位 Byte
	 * @return
	 * 
	 * 		<pre>
	 * 使用方式
	 * MultipartFile file = multiRequest.getFile("file");获取文件
	 * InputStream input = file.getInputStream();获取文件流
	 * File source = new File(filePath);file.transferTo(source);保存文件到本地
	 * String name = multiRequest.getParameter("name");获取参数
	 *         </pre>
	 */
	public static MultipartHttpServletRequest createMultipartHttpServletRequest(HttpServletRequest request,
			long maxSize) throws MaxUploadSizeExceededException, SizeLimitExceededException {
		CommonsMultipartResolver resolver = null;
		MultipartHttpServletRequest multiRequest = null;
		resolver = new CommonsMultipartResolver();
		resolver.setDefaultEncoding("UTF-8");
		resolver.setMaxUploadSize(maxSize);// 20M
		resolver.setServletContext(request.getSession().getServletContext());
		resolver.setMaxInMemorySize(1024 * 1024);
		multiRequest = resolver.resolveMultipart(request);
		return multiRequest;
	}

	public static MultipartFile createFileFromRequest(HttpServletRequest request) {
		MultipartHttpServletRequest multipartHttpServletRequest = null;
		CommonsMultipartResolver resolver = null;
		resolver = new CommonsMultipartResolver();
		resolver.setDefaultEncoding("UTF-8");
		// resolver.setMaxUploadSize(maxSize);// 20M
		resolver.setServletContext(request.getSession().getServletContext());
		resolver.setMaxInMemorySize(1024 * 1024);
		multipartHttpServletRequest = resolver.resolveMultipart(request);
		MultipartFile file = multipartHttpServletRequest.getFile("file");
		return file;
	}

	/**
	 * 上传图片
	 * 
	 * @param multipartFile
	 * @param request
	 * @return
	 * @throws IOException
	 */
	public static String uploadImg(MultipartFile multipartFile, HttpServletRequest request) throws IOException {
		String filePath = request.getSession().getServletContext().getRealPath("/") + "upload/";
		System.err.println(filePath);
		File saveDir = new File(filePath);
		if (!saveDir.exists())
			saveDir.mkdirs();
		System.err.println(filePath);
		// 图片类型
		String type = multipartFile.getOriginalFilename().substring(
				multipartFile.getOriginalFilename().lastIndexOf(".") + 1, multipartFile.getOriginalFilename().length());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
		Random r = new Random();
		String imgName = "";
		if (type.equals("jpg")) {
			imgName = sdf.format(new Date()) + r.nextInt(100) + ".jpg";
		} else if (type.equals("png")) {
			imgName = sdf.format(new Date()) + r.nextInt(100) + ".png";
		} else if (type.equals("jpeg")) {
			imgName = sdf.format(new Date()) + r.nextInt(100) + ".jpeg";
		} else if (type.equals("gif")) {
			imgName = sdf.format(new Date()) + r.nextInt(100) + ".gif";
		}
		FileUtils.writeByteArrayToFile(new File(filePath, imgName), multipartFile.getBytes());
		return "upload/" + imgName;
	}

	public static boolean chkImg(MultipartFile multipartFile, HttpServletRequest request) {
		if (!multipartFile.isEmpty()) {
			// 图片类型
			String type = multipartFile.getOriginalFilename().substring(
					multipartFile.getOriginalFilename().lastIndexOf(".") + 1,
					multipartFile.getOriginalFilename().length());
			if (!"jpg".equals(type) && !"jpeg".equals(type) && !"png".equals(type) && !"gif".equals(type)) {
				return false;
			}
		}
		return true;
	}

	/**
	 * 删除之前的图片
	 * 
	 * @param request
	 * @param imgPath
	 */
	public static void deleteBeforeImg(HttpServletRequest request, String imgPath) {
		// 删除之前的图片
		String filePath = request.getSession().getServletContext().getRealPath("/");
		File file = new File(filePath + imgPath);
		file.delete();
	}

}
