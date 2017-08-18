#ifndef PRODUCTMODELSERIALIZATOR_H
#define PRODUCTMODELSERIALIZATOR_H

#include "productmodel.h"

class ProductModelSerializator
{
public:
    static QByteArray serialize(ProductModel *model);
    static void deserialize(const QByteArray &array, ProductModel *model);
};

#endif // PRODUCTMODELSERIALIZATOR_H
