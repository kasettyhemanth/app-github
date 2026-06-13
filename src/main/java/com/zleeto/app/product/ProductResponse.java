package com.zleeto.app.product;

import java.math.BigDecimal;

public record ProductResponse(Long id, String name, String category, BigDecimal price) {

    public static ProductResponse from(Product product) {
        return new ProductResponse(
                product.getId(),
                product.getName(),
                product.getCategory(),
                product.getPrice());
    }
}
