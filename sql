-- Delete product variations
DELETE p, pm
FROM wp_posts p
JOIN wp_postmeta pm ON pm.post_id = p.ID
WHERE p.post_type = 'product_variation';

-- Delete products
DELETE p, pm
FROM wp_posts p
JOIN wp_postmeta pm ON pm.post_id = p.ID
WHERE p.post_type = 'product';

-- Delete term relationships for product categories
DELETE tr
FROM wp_term_relationships tr
JOIN wp_term_taxonomy tt ON tt.term_taxonomy_id = tr.term_taxonomy_id
WHERE tt.taxonomy = 'product_cat';

-- Delete term taxonomy for product categories
DELETE FROM wp_term_taxonomy
WHERE taxonomy = 'product_cat';

-- Delete terms for product categories
DELETE t, tm
FROM wp_terms t
JOIN wp_termmeta tm ON tm.term_id = t.term_id
WHERE t.term_id NOT IN (SELECT term_id FROM wp_term_taxonomy);

-- Delete attribute taxonomies
DELETE FROM wp_woocommerce_attribute_taxonomies;

-- Delete term relationships for attribute terms
DELETE tr
FROM wp_term_relationships tr
JOIN wp_term_taxonomy tt ON tt.term_taxonomy_id = tr.term_taxonomy_id
WHERE tt.taxonomy LIKE 'pa_%';

-- Delete term taxonomy for attribute terms
DELETE FROM wp_term_taxonomy
WHERE taxonomy LIKE 'pa_%';

-- Delete terms for attribute terms
DELETE t, tm
FROM wp_terms t
JOIN wp_termmeta tm ON tm.term_id = t.term_id
WHERE t.term_id NOT IN (SELECT term_id FROM wp_term_taxonomy);

-- Delete orphaned postmeta after deleting products and product categories:
DELETE pm
FROM wp_postmeta pm
LEFT JOIN wp_posts p ON p.ID = pm.post_id
WHERE p.ID IS NULL;

-- Delete orphaned termmeta after deleting attribute terms:
DELETE tm
FROM wp_termmeta tm
LEFT JOIN wp_terms t ON t.term_id = tm.term_id
WHERE t.term_id IS NULL;
