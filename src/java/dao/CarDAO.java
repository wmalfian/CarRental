/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author wmalf
 */
import java.sql.*;
import java.util.*;
import model.Car;
import util.DBConnection;

public class CarDAO {

    public boolean addCar(Car car) {
        String sql = "INSERT INTO cars (brand, model, type, price_per_day, status, fuel_type, image_path) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, car.getBrand());
            stmt.setString(2, car.getModel());
            stmt.setString(3, car.getType());
            stmt.setDouble(4, car.getPricePerDay());
            stmt.setString(5, car.getStatus());
            stmt.setString(6, car.getFuelType());
            stmt.setString(7, car.getImagePath());
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Car> getAvailableCars() {
        List<Car> list = new ArrayList<>();
        String sql = "SELECT * FROM cars WHERE status='available'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Car car = new Car();
                car.setCarId(rs.getInt("car_id"));
                car.setBrand(rs.getString("brand"));
                car.setModel(rs.getString("model"));
                car.setType(rs.getString("type"));
                car.setPricePerDay(rs.getDouble("price_per_day"));
                car.setStatus(rs.getString("status"));
                car.setFuelType(rs.getString("fuel_type"));
                car.setImagePath(rs.getString("image_path"));
                list.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateCarStatus(int carId, String newStatus) {
        String sql = "UPDATE cars SET status = ? WHERE car_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, carId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    
    public boolean updateCar(Car car) {
        String sql = "UPDATE cars SET brand = ?, model = ?, type = ?, price_per_day = ?, fuel_type = ?, image_path = ? WHERE car_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, car.getBrand());
            stmt.setString(2, car.getModel());
            stmt.setString(3, car.getType());
            stmt.setDouble(4, car.getPricePerDay());
            stmt.setString(5, car.getFuelType());
            stmt.setString(6, car.getImagePath());
            stmt.setInt(7, car.getCarId());

            int rows = stmt.executeUpdate();
            return rows > 0; // ✅ Success if at least one row was updated

        } catch (Exception e) {
            e.printStackTrace();
            return false; // ❌ Failed update
        }
    }

    
    public boolean deleteCar(int carId) {
        String sql = "DELETE FROM cars WHERE car_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, carId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0; // ✅ Return true if deletion successful

        } catch (Exception e) {
            e.printStackTrace();
            return false; // ❌ Return false if any error occurs
        }
    }

    
    public Car getCarById(int carId) {
        String sql = "SELECT * FROM cars WHERE car_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Car car = new Car();
                    car.setCarId(rs.getInt("car_id"));
                    car.setBrand(rs.getString("brand"));
                    car.setModel(rs.getString("model"));
                    car.setType(rs.getString("type"));
                    car.setPricePerDay(rs.getDouble("price_per_day"));
                    car.setStatus(rs.getString("status"));
                    car.setFuelType(rs.getString("fuel_type"));
                    car.setImagePath(rs.getString("image_path"));
                    return car;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Car> getAllCars() {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT * FROM cars";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Car car = new Car();
                car.setCarId(rs.getInt("car_id"));
                car.setBrand(rs.getString("brand"));
                car.setModel(rs.getString("model"));
                car.setType(rs.getString("type"));
                car.setPricePerDay(rs.getDouble("price_per_day"));
                car.setStatus(rs.getString("status"));
                car.setFuelType(rs.getString("fuel_type"));
                car.setImagePath(rs.getString("image_path"));
                cars.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cars;
    }
    
    public List<Car> filterAvailableCars(String brand, String type, String fuel) {
        List<Car> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM cars WHERE status='available'");

        if (brand != null && !brand.isEmpty()) {
            sql.append(" AND brand LIKE ?");
        }
        if (type != null && !type.isEmpty()) {
            sql.append(" AND type=?");
        }
        if (fuel != null && !fuel.isEmpty()) {
            sql.append(" AND fuel_type=?");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (brand != null && !brand.isEmpty()) {
                stmt.setString(index++, "%" + brand + "%");
            }
            if (type != null && !type.isEmpty()) {
                stmt.setString(index++, type);
            }
            if (fuel != null && !fuel.isEmpty()) {
                stmt.setString(index++, fuel);
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Car car = new Car();
                car.setCarId(rs.getInt("car_id"));
                car.setBrand(rs.getString("brand"));
                car.setModel(rs.getString("model"));
                car.setType(rs.getString("type"));
                car.setPricePerDay(rs.getDouble("price_per_day"));
                car.setStatus(rs.getString("status"));
                car.setFuelType(rs.getString("fuel_type"));
                car.setImagePath(rs.getString("image_path"));
                list.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<String> getAvailableBrands() {
        List<String> brands = new ArrayList<>();
        String sql = "SELECT DISTINCT brand FROM cars WHERE status = 'available'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                brands.add(rs.getString("brand"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return brands;
    }
    
    public List<Car> getRentedCars() {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT * FROM cars WHERE status = 'rented'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Car car = new Car();
                car.setCarId(rs.getInt("car_id"));
                car.setBrand(rs.getString("brand"));
                car.setModel(rs.getString("model"));
                car.setType(rs.getString("type"));
                car.setPricePerDay(rs.getDouble("price_per_day"));
                car.setStatus(rs.getString("status"));
                car.setFuelType(rs.getString("fuel_type"));
                car.setImagePath(rs.getString("image_path"));
                cars.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cars;
    }



}
