#include "productitem.h"

ProductItem::ProductItem()
{}

ProductItem::ProductItem(const QString &imagePath, const QString &name, double cost,
                         const QString &currency)
    : mImagePath(imagePath),
      mName(name),
      mCost(cost),
      mSelected(false),
      mCurrency(currency)
{}

void ProductItem::setImagePath(const QString &imagePath)
{
    mImagePath = imagePath;
}

void ProductItem::setName(const QString &name)
{
    mName = name;
}

void ProductItem::setCost(double cost)
{
    mCost = cost;
}

void ProductItem::setSelected(bool selected)
{
    mSelected = selected;
}

void ProductItem::setCurrency(const QString &currency)
{
    mCurrency = currency;
}

QString ProductItem::imagePath() const
{
    return mImagePath;
}

QString ProductItem::name() const
{
    return mName;
}

double ProductItem::cost() const
{
    return mCost;
}

bool ProductItem::isSelected() const
{
    return mSelected;
}

QString ProductItem::currency() const
{
    return mCurrency;
}

void ProductItem::changeSelection()
{
    mSelected = !mSelected;
}