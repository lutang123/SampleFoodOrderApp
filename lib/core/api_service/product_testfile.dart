import 'package:sample_food_order_app/core/models/product/product.dart';

Future<Product> getProductFromTest() {
  const String product = """
  {
   "id":13,
   "name":"Salad",
   "description":"This is the best salad in the world! Buy this salad, you will love it! Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. ",
   "featured_image": null,
   "variants":[
      {
         "id":25,
         "name":"Chicken Salad",
         "price":"1000",
         "display_price":"1000",
         "sku":"",
         "resource_id":null,
         "pos_id":null,
         "automatic_fulfillment":false,
         "is_physical_product":true,
         "is_gift_card":false,
         "is_taxable":true,
         "barcode":"",
         "product":13,
         "published_at":"2021-02-25T18:43:24.001Z",
         "created_at":"2021-02-25T18:43:24.018Z",
         "updated_at":"2021-02-25T18:50:13.562Z",
         "is_default":true,
         "featured_image":null,
         "inventories":[
            {
               "id":44,
               "resource_id":null,
               "pos_id":null,
               "variant":25,
               "location":1,
               "count":"10",
               "threshold":0,
               "continue_selling_out_of_stock":false,
               "unlimited":true,
               "published_at":"2021-02-25T18:43:23.918Z",
               "created_at":"2021-02-25T18:43:23.925Z",
               "updated_at":"2021-02-25T18:43:24.042Z"
            }
         ]
      },
      {
         "id":26,
         "name":"Vegan Salad",
         "price":"900",
         "display_price":"0",
         "sku":"",
         "resource_id":null,
         "pos_id":null,
         "automatic_fulfillment":false,
         "is_physical_product":true,
         "is_gift_card":false,
         "is_taxable":true,
         "barcode":"",
         "product":13,
         "published_at":"2021-02-25T18:43:24.121Z",
         "created_at":"2021-02-25T18:43:24.126Z",
         "updated_at":"2021-02-25T18:50:13.562Z",
         "is_default":false,
         "featured_image":null,
         "inventories":[
             {
               "id":44,
               "resource_id":null,
               "pos_id":null,
               "variant":25,
               "location":1,
               "count":"10",
               "threshold":0,
               "continue_selling_out_of_stock":false,
               "unlimited":true,
               "published_at":"2021-02-25T18:43:23.918Z",
               "created_at":"2021-02-25T18:43:23.925Z",
               "updated_at":"2021-02-25T18:43:24.042Z"
            }
         ]
      }
   ],
   "modification_groups":[
      {
         "id":1,
         "name":"Choose Dressing",
         "description":"",
         "resource_id":null,
         "pos_id":null,
         "required":true,
         "minimum":1,
         "maximum":2,
         "store":1,
         "published_at":"2021-02-25T18:48:16.233Z",
         "created_at":"2021-02-25T18:48:16.238Z",
         "updated_at":"2021-02-25T18:48:16.264Z",
         "modifications":[
            {
               "id":1,
               "name":"Dressing 1",
               "description":"",
               "resource_id":null,
               "pos_id":null,
               "price":"0",
               "allow_quantity":true,
               "variant":27,
               "modification_group":4,
               "published_at":"2021-02-25T18:48:16.179Z",
               "created_at":"2021-02-25T18:48:16.186Z",
               "updated_at":"2021-02-25T18:48:16.260Z"
            },
            {
               "id":2,
               "name":"Dressing 2",
               "description":"",
               "resource_id":null,
               "pos_id":null,
               "price":"0",
               "allow_quantity":true,
               "variant":27,
               "modification_group":4,
               "published_at":"2021-02-25T18:48:16.179Z",
               "created_at":"2021-02-25T18:48:16.186Z",
               "updated_at":"2021-02-25T18:48:16.260Z"
            },
            {
               "id":3,
               "name":"Dressing 3",
               "description":"",
               "resource_id":null,
               "pos_id":null,
               "price":"0",
               "allow_quantity":true,
               "variant":27,
               "modification_group":4,
               "published_at":"2021-02-25T18:48:16.179Z",
               "created_at":"2021-02-25T18:48:16.186Z",
               "updated_at":"2021-02-25T18:48:16.260Z"
            }
         ]
      },
      {
         "id":3,
         "name":"Add Drinks",
         "description":"",
         "resource_id":null,
         "pos_id":null,
         "required":false,
         "minimum":0,
         "maximum":null,
         "store":1,
         "published_at":"2021-02-25T18:48:16.233Z",
         "created_at":"2021-02-25T18:48:16.238Z",
         "updated_at":"2021-02-25T18:48:16.264Z",
         "modifications":[
            {
               "id":13,
               "name":"Coke",
               "description":"",
               "resource_id":null,
               "pos_id":null,
               "price":"100",
               "allow_quantity":true,
               "variant":27,
               "modification_group":4,
               "published_at":"2021-02-25T18:48:16.179Z",
               "created_at":"2021-02-25T18:48:16.186Z",
               "updated_at":"2021-02-25T18:48:16.260Z"
            },
            {
               "id":14,
               "name":"Diet Coke",
               "description":"",
               "resource_id":null,
               "pos_id":null,
               "price":"200",
               "allow_quantity":true,
               "variant":28,
               "modification_group":4,
               "published_at":"2021-02-25T18:48:16.209Z",
               "created_at":"2021-02-25T18:48:16.213Z",
               "updated_at":"2021-02-25T18:48:16.260Z"
            }
         ]
      }
   ]
}""";

  return Future.value(Product.fromJson(product));
}
