package controller;

import dao.BookingDAO;
import dao.CarDAO;
import model.Booking;
import model.Car;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import java.awt.Color;

@WebServlet("/DownloadInvoiceServlet")
public class DownloadInvoiceServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        BookingDAO bookingDao = new BookingDAO();
        CarDAO carDao = new CarDAO();

        Booking booking = bookingDao.getBookingById(bookingId);
        Car car = carDao.getCarById(booking.getCarId());

        if (booking != null && car != null) {
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment;filename=invoice_" + bookingId + ".pdf");

            try {
                OutputStream out = response.getOutputStream();
                Document document = new Document();
                PdfWriter.getInstance(document, out);

                document.open();

                try {
                    Image logo = Image.getInstance(getServletContext().getRealPath("/images/logo.png"));
                    logo.scaleToFit(100, 100);
                    logo.setAlignment(Image.ALIGN_RIGHT);
                    document.add(logo);
                } catch (Exception e) {
                }

                Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, Color.BLUE);
                Font sectionFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, Color.DARK_GRAY);
                Font contentFont = FontFactory.getFont(FontFactory.HELVETICA, 12);

                Paragraph title = new Paragraph("Booking Invoice", titleFont);
                title.setAlignment(Element.ALIGN_CENTER);
                title.setSpacingAfter(15);
                document.add(title);

                document.add(new Paragraph("Booking ID: " + booking.getBookingId(), sectionFont));
                document.add(new Paragraph("Status: " + booking.getStatus(), contentFont));
                document.add(new Paragraph("Start Date: " + booking.getStartDate(), contentFont));
                document.add(new Paragraph("End Date: " + booking.getEndDate(), contentFont));
                document.add(Chunk.NEWLINE);

                document.add(new Paragraph("Car Details:", sectionFont));
                document.add(new Paragraph("Car: " + car.getBrand() + " " + car.getModel(), contentFont));
                document.add(Chunk.NEWLINE);

                document.add(new Paragraph("Total Cost: RM " + booking.getTotalCost(), sectionFont));

                document.close();
            } catch (DocumentException e) {
                e.printStackTrace();
                response.getWriter().println("Failed to generate PDF: " + e.getMessage());
            }
        } else {
            response.getWriter().println("Booking or Car not found.");
        }
    }
}
