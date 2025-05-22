package listener;

import util.BookingQueueProcessor;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class BookingQueueListener implements ServletContextListener {
    private BookingQueueProcessor processor;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        processor = BookingQueueProcessor.getInstance(sce.getServletContext());
        System.out.println("BookingQueueProcessor initialized");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (processor != null) {
            processor.shutdown();
            System.out.println("BookingQueueProcessor shut down");
        }
    }
}