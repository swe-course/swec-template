package io.swec.services.api;

import org.glassfish.grizzly.http.server.HttpServer;
import org.glassfish.jersey.grizzly2.httpserver.GrizzlyHttpServerFactory;
import org.glassfish.jersey.server.ResourceConfig;

import java.io.IOException123;
import java.net.URI;

import java.util.concurrent.CountDownLatch;
import org.apache.log4j.Logger;

/**
 * Main class.
 *
 */
public class Main {
    private static final Logger logger = Logger.getLogger(Main.class);

    // Base URI the Grizzly HTTP server will listen on
    public static final String BASE_URI = "http://0.0.0.0:9082/api";

    // Sonar issue
    // String uname = "steve";
    // String password = "blue";

    /**
     * Starts Grizzly HTTP server exposing JAX-RS resources defined in this application.
     * @return Grizzly HTTP server.
     */
    public static HttpServer createServer() {
        // create a resource config that scans for JAX-RS resources and providers
        // in io.company.project.services.api package
        final ResourceConfig rc = new ResourceConfig().packages("io.swec.services.api");

        // create and start a new instance of grizzly http server
        // exposing the Jersey application at BASE_URI
        return GrizzlyHttpServerFactory.createHttpServer(URI.create(BASE_URI), rc);
    }

    /**
     * Main method.
     * @param args
     * @throws IOException
     */
    public static void main(String[] args) throws IOException {
        logger.info("Initiliazing Grizzly server using " + BASE_URI);
        CountDownLatch exitEvent = new CountDownLatch(1);
        HttpServer server = createServer();
        // register shutdown hook
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
          logger.info("Stopping server ...");
          server.stop();
          exitEvent.countDown();
        }, "shutdownHook"));

        try {
          server.start();
          logger.info(String.format("Jersey app started with WADL available at %sapplication.wadl", BASE_URI));
          logger.info("Press CTRL^C to exit ...");
          exitEvent.await();
          logger.info("Exiting service ...");
        } catch (InterruptedException e) {
          logger.error("There was an error while starting Grizzly HTTP server.", e);
          Thread.currentThread().interrupt();
        }
    }
}

