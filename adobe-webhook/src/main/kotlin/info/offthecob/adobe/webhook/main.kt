package info.offthecob.adobe.webhook

import com.beust.klaxon.Klaxon
import com.beust.klaxon.json
import java.io.*
import java.security.cert.CertPathParameters

/**
 * {
"resource": "Resource path",
"path": "Path parameter",
"httpMethod": "Incoming request's method name"
"headers": {String containing incoming request headers}
"multiValueHeaders": {List of strings containing incoming request headers}
"queryStringParameters": {query string parameters }
"multiValueQueryStringParameters": {List of query string parameters}
"pathParameters":  {path parameters}
"stageVariables": {Applicable stage variables}
"requestContext": {Request context, including authorizer-returned key-value pairs}
"body": "A JSON string of the request payload."
"isBase64Encoded": "A boolean flag to indicate if the applicable request payload is Base64-encode"
}
 */

data class HandlerInput(
        val resource: String,
        val path: String,
        val httpMethod: String,
        val headers: Map<String, String>,
        val multiValueHeaders: Map<String, List<String>>,
        val queryStringParameters: Map<String, String>,
        val multiValueQueryStringParameters: Map<String, String>,
        val pathParameters: Map<String, String>,
        val body: String = "",
        val isBase64Encoded: Boolean)

data class HandlerOutput(
        val isBase64Encoded: Boolean = false,
        val statusCode: Int = 200,
        val headers: Map<String, String> = mutableMapOf(),
        val multiValueHeaders: Map<String, List<String>> = mutableMapOf(),
        val body: String)

public class AdobeWebHook {

    fun handler(input: InputStream, output: OutputStream): Unit {
        println("hello from kotlin")
        val inputString = input.bufferedReader().use { it.readText() }
        println("inputString: ${inputString}")
        try {
            val result = Klaxon().parse<HandlerInput>(inputString)
            println("result: ${result?.httpMethod}")
            val output = HandlerOutput(body = "ok")

        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
