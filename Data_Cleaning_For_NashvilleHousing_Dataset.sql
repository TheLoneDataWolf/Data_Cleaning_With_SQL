
-- Overview Of The Data.

SELECT 
       * 
FROM Data_Cleaning.dbo.NashvilleHousing




-- Adding A New Column and chaning the Data Type From DATETIME to DATE.

ALTER TABLE Data_Cleaning.dbo.NashvilleHousing
Add SaleDateConverted Date;

Update Data_Cleaning.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Filling Null Values On The OwnerAddress Column.
-- 2nd Query is to Self Join To Identify Missing Address and Filling it Accordingly.
-- Updating The Table With the New Result From The 2nd Query.
Select *
From Data_Cleaning.dbo.NashvilleHousing
Where PropertyAddress is null
order by ParcelID


Select 
       a.ParcelID, 
	   a.PropertyAddress, 
	   b.ParcelID, 
	   b.PropertyAddress, 
	   ISNULL(a.PropertyAddress,b.PropertyAddress) AS PropertyAddressConverted

From Data_Cleaning.dbo.NashvilleHousing a
JOIN Data_Cleaning.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Updating The Table With the New Result From The Query Above

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Data_Cleaning.dbo.NashvilleHousing a
JOIN Data_Cleaning.dbo.NashvilleHousing b
     ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null



-- Filtering out the PropertyAddress and OwnerAddress Columns into individual Columns as Address, City, anmd State.

-- PropertyAddress
SELECT 
      PropertyAddress
FROM Data_Cleaning.dbo.NashvilleHousing


SELECT 
      SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
	  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address

FROM Data_Cleaning.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD Property_Address Nvarchar(255);

UPDATE NashvilleHousing
SET Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing 
ADD Property_City Nvarchar(255)

UPDATE NashvilleHousing
SET Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))
     

-- Ownwer Address using PARSENAME Instead of SUBSTRING and CHARINDEX
-- Note that PARSENAME index works in reverse(last word is index number 1)

SELECT 
       OwnerAddress
FROM Data_Cleaning.dbo.NashvilleHousing


SELECT 
       PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3) AS OwnerAddress,
	   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS OwnerCity,
	   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS OwnerState

FROM Data_Cleaning.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add Owner_Address Nvarchar(255);

Update NashvilleHousing
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add Owner_City Nvarchar(255);

Update NashvilleHousing
SET Owner_City = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add Owner_State Nvarchar(255);

Update NashvilleHousing
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


SELECT 
      *
FROM Data_Cleaning.dbo.NashvilleHousing



-- Changing the 'Y' and 'N' to YES and NO in SoldAsVacant Column to make it more readable
-- Identifying the Unique value as well as the Count


SELECT
      DISTINCT(SoldAsVacant),
	  COUNT(SoldAsVacant) AS Count	  

FROM Data_Cleaning.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2 DESC


SELECT 
       SoldAsVacant,
	   CASE 
	        WHEN SoldAsVacant = 'Y' THEN 'YES'
			WHEN SoldAsVacant = 'N' THEN 'NO'
			ELSE SoldAsVacant
			END
FROM Data_Cleaning.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant =  CASE 
	                    WHEN SoldAsVacant = 'Y' THEN 'YES'
			            WHEN SoldAsVacant = 'N' THEN 'NO'
			            ELSE SoldAsVacant
			        END



-- Removing Duplicates with ROW_NUMBER() as Identifier


 WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Data_Cleaning.dbo.NashvilleHousing
--order by ParcelID
)
Select *
--DELETE
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



-- Deleting Useless Columns


Select *
From Data_Cleaning.dbo.NashvilleHousing


ALTER TABLE Data_Cleaning.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
