package light.mvc.service.email;

import java.util.Map;

public interface MailSenderServiceI {
	public void sendMailWithVelocityTemplate(String to,String mailSubject, String templateLocation,
			Map<String, Object> velocityContext);
}
