package controller;

import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import dao.PaymentDAO;
import dao.BookingDAO;
import dao.CarDAO;
import dao.UserDAO;
import model.Payment;
import model.Booking;
import model.Car;
import model.User;

import java.awt.Color;

@WebServlet("/DownloadReceipt")
public class DownloadReceiptServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        PaymentDAO paymentDao = new PaymentDAO();
        BookingDAO bookingDao = new BookingDAO();
        CarDAO carDao = new CarDAO();
        UserDAO userDao = new UserDAO();

        Payment payment = paymentDao.getPaymentByBookingId(bookingId);
        Booking booking = bookingDao.getBookingById(bookingId);
        Car car = carDao.getCarById(booking.getCarId());
        User user = userDao.getUserById(booking.getUserId());

        if (payment != null && booking != null && car != null && user != null) {
            String status = payment.getPaymentMethod().equalsIgnoreCase("Cash") ? "Pending" : "Paid";

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment;filename=receipt_" + bookingId + ".pdf");

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
                } catch (Exception e) { }

                Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, Color.BLUE);
                Font labelFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);
                Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 12);

                Paragraph title = new Paragraph("Car Rental Receipt (" + status + ")", titleFont);
                title.setAlignment(Element.ALIGN_CENTER);
                title.setSpacingAfter(20);
                document.add(title);

                PdfPTable table = new PdfPTable(2);
                table.setWidthPercentage(100);
                table.setSpacingBefore(10f);

                table.addCell(new Phrase("Receipt No:", labelFont));
                table.addCell(new Phrase(String.valueOf(payment.getPaymentId()), normalFont));

                table.addCell(new Phrase("Booking ID:", labelFont));
                table.addCell(new Phrase(String.valueOf(booking.getBookingId()), normalFont));

                table.addCell(new Phrase("Customer:", labelFont));
                table.addCell(new Phrase(user.getUsername(), normalFont));

                table.addCell(new Phrase("Car Booked:", labelFont));
                table.addCell(new Phrase(car.getBrand() + " " + car.getModel(), normalFont));

                table.addCell(new Phrase("Rental Dates:", labelFont));
                table.addCell(new Phrase(booking.getStartDate() + " to " + booking.getEndDate(), normalFont));

                table.addCell(new Phrase("Booking Status:", labelFont));
                table.addCell(new Phrase(booking.getStatus(), normalFont));

                table.addCell(new Phrase("Price Per Day:", labelFont));
                table.addCell(new Phrase("RM " + String.format("%.2f", car.getPricePerDay()), normalFont));

                table.addCell(new Phrase("Total Amount:", labelFont));
                table.addCell(new Phrase("RM " + String.format("%.2f", payment.getAmount()), normalFont));

                table.addCell(new Phrase("Payment Method:", labelFont));
                table.addCell(new Phrase(payment.getPaymentMethod(), normalFont));

                table.addCell(new Phrase("Payment Date:", labelFont));
                table.addCell(new Phrase(payment.getPaymentDate().toString(), normalFont));

                document.add(table);
                document.add(Chunk.NEWLINE);

                Paragraph note = new Paragraph(
                    status.equals("Pending")
                        ? "⚠️ This booking is pending cash payment confirmation."
                        : "✅ Payment successfully received. Thank you for your booking!",
                    normalFont);
                note.setSpacingBefore(10f);
                document.add(note);

                document.close();

            } catch (DocumentException e) {
                e.printStackTrace();
                response.getWriter().println("Failed to generate PDF: " + e.getMessage());
            }

        } else {
            response.getWriter().println("Missing details. Cannot generate receipt.");
        }
    }
}

