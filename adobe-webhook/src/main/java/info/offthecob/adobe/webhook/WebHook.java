package info.offthecob.adobe.webhook;


import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class WebHook implements RequestHandler<String, Void> {

    @Override
    public Void handleRequest(String input, Context context) {
        LambdaLogger logger = context.getLogger();
        logger.log("working");
        return null;
    }
}
