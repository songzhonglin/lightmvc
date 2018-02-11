package light.mvc.utils;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * propertis文件工具
 * 
 * @author szl
 *
 */
@Component
public class Util implements InitializingBean {
	private static Util util;

	@Override
	public void afterPropertiesSet() throws Exception {
		Util.util = this;
	}

	@Value("${mail.nickName}")
	private String nickName;

	public static String getNickName() {
		return Util.util.nickName;
	}

}
