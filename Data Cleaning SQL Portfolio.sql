/*
Cleaning Data in SQL Queries
*/


Select *
From PortfolioProjectAlton.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate) 
From PortfolioProjectAlton.dbo.NashVilleHousing


Update NashVilleHousing
Set SaleDate = CONVERT(Date, SaleDate)

-- If it doesn't Update properly

Alter Table NashVilleHousing
Add SaleDateConverted Date;


Update NashVilleHousing
Set SaleDateConverted = CONVERT(Date, SaleDate)


--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data


Select *
From PortfolioProjectAlton.dbo.NashVilleHousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProjectAlton.dbo.NashVilleHousing a
Join PortfolioProjectAlton.dbo.NashVilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProjectAlton.dbo.NashVilleHousing a
Join PortfolioProjectAlton.dbo.NashVilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProjectAlton.dbo.NashVilleHousing
--Where PropertyAddress is null
--order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From PortfolioProjectAlton.dbo.NashVilleHousing


Alter Table NashVilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashVilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table NashVilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashVilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select *
From PortfolioProjectAlton.dbo.NashVilleHousing



Select OwnerAddress
From PortfolioProjectAlton.dbo.NashVilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',','.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',','.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)
From PortfolioProjectAlton.dbo.NashVilleHousing


Alter Table NashVilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashVilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') , 3)

Alter Table NashVilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashVilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.') , 2)

Alter Table NashVilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashVilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)


Select *
From PortfolioProjectAlton.dbo.NashVilleHousing


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProjectAlton.dbo.NashVilleHousing
Group by SoldAsVacant
order by 2



Select SoldAsVacant
,CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	ELSE SoldAsVacant
	END
From PortfolioProjectAlton.dbo.NashVilleHousing


Update NashVilleHousing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	ELSE SoldAsVacant
	END



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				LegalReference
				ORDER  BY
					UniqueID
					) row_num

From PortfolioProjectAlton.dbo.NashVilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
order by PropertyAddress


Select *
From PortfolioProjectAlton.dbo.NashVilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From PortfolioProjectAlton.dbo.NashVilleHousing

ALTER TABLE PortfolioProjectAlton.dbo.NashVilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProjectAlton.dbo.NashVilleHousing
DROP COLUMN SaleDate







