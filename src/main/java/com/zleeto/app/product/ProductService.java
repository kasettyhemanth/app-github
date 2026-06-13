package com.zleeto.app.product;

import java.util.List;

import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

@Service
public class ProductService {

    private final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<ProductResponse> getProducts(String category) {
        List<Product> products = (category == null || category.isBlank())
                ? productRepository.findAll(Sort.by(Sort.Direction.ASC, "name"))
                : productRepository.findByCategoryIgnoreCaseOrderByNameAsc(category);

        return products.stream()
                .map(ProductResponse::from)
                .toList();
    }
}
