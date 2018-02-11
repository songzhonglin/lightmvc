package light.mvc.utils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 字符串工具類
 * 
 * @author songzhonglin
 *
 */
public class StringUtil {

	/**
	 * 格式化字符串
	 * 
	 * 例：formateString("xxx{0}bbb",1) = xxx1bbb
	 * 
	 * @param str
	 * @param params
	 * @return
	 */
	public static String formateString(String str, String... params) {
		for (int i = 0; i < params.length; i++) {
			str = str.replace("{" + i + "}", params[i] == null ? "" : params[i]);
		}
		return str;
	}

	/**
	 * 字符串時候為空
	 * 
	 * @param v
	 * @return
	 */
	public static boolean isEmpty(String v) {
		if (v == null || v.length() <= 0) {
			return true;
		}
		return false;
	}

	/**
	 * 字符串時候為空
	 * 
	 * @param v
	 * @return
	 */
	public static boolean isEmpty(Object obj) {
		if (obj == null) {
			return true;
		}
		return false;
	}
	
	/**
	 * 字符串時候為空
	 * 
	 * @param v
	 * @return
	 */
	public static boolean isNotEmpty(Object obj) {
		if (obj == null) {
			return false;
		}
		return true;
	}

	/**
	 * 字符串時候為空
	 * 
	 * @param v
	 * @return
	 */
	public static boolean isNotEmpty(String v) {
		if (v == null || v.length() <= 0) {
			return false;
		}
		return true;
	}

	/**
	 * 将String型转换为Int型
	 * 
	 * @param intstr
	 * @return
	 */
	public static int stringTolnt(String intstr) {
		Integer integer;
		integer = Integer.valueOf(intstr);
		return integer.intValue();
	}

	/**
	 * 将Int型转换为String型
	 * 
	 * @param value
	 * @return
	 */
	public static String intToString(int value) {
		Integer integer = new Integer(value);
		return integer.toString();
	}

	/**
	 * 将String型转换为float型
	 * 
	 * @param floatstr
	 * @return
	 */
	public static float stringToFloat(String floatstr) {
		Float floatee;
		floatee = Float.valueOf(floatstr);
		return floatee.floatValue();
	}

	/**
	 * 将float型转换为String型
	 * 
	 * @param value
	 * @return
	 */
	public static String floatToString(float value) {
		Float floatee = new Float(value);
		return floatee.toString();
	}

	/**
	 * 将String型转换为sqlDate型
	 * 
	 * @param dateStr
	 * @return
	 */
	public static java.sql.Date stringToDate(String dateStr) {
		return java.sql.Date.valueOf(dateStr);
	}

	/**
	 * 将sqlDate型转换为String型
	 * 
	 * @param datee
	 * @return
	 */
	public static String dateToString(java.sql.Date datee) {
		return datee.toString();
	}
	/**
	 * 
	 * @param value 当前值
	 * @param len 不满足长度
	 * @return
	 */
	public static String getZeroToLeft(int value,String len) {
		if (isNotEmpty(intToString(value)) && isNotEmpty(len)) {
			String format="%0"+len+"d";
			System.out.println(format);
			String str=String.format(format, value);
			return str;
		}
		return null;

	}
	
	/**
     * 利用正则表达式判断字符串是否是数字
     * @param str
     * @return
     */
    public static boolean isNumeric(String str){
           Pattern pattern = Pattern.compile("[0-9]*");
           Matcher isNum = pattern.matcher(str);
           if( !isNum.matches() ){
               return false;
           }
           return true;
    }

	public static void main(String[] args) {
		int n = 1;
//		String str = String.format("%05d", n);
//		System.out.println(str);
		String zero=getZeroToLeft(123,"4");
		System.out.println(zero);
	}

}
