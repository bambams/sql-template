BEGIN TRANSACTION;

SET FMTONLY OFF;
SET NOCOUNT OFF;
SET NOEXEC OFF;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET XACT_ABORT ON;

DECLARE @commit BIT = 0;
DECLARE @dto VARCHAR(255);
DECLARE @fmt VARCHAR(2000);
DECLARE @msg VARCHAR(2000);
DECLARE @ret INT;
DECLARE @select_xact_msg BIT = 1;
DECLARE @tfsid INT = 0;

BEGIN TRY
    

    SET FMTONLY OFF;
    SET NOEXEC OFF;
    SET NOCOUNT ON;
    SET @dto = CAST(SYSDATETIMEOFFSET() AS VARCHAR(255));
    IF @commit = 1 BEGIN
        SET @fmt = '[#%05d] Committing the transaction at %s...';
        RAISERROR(@fmt, 0, 0, @tfsid, @dto) WITH NOWAIT;
        IF @select_xact_msg = 1 SELECT REPLACE(REPLACE(@fmt COLLATE DATABASE_DEFAULT, '%05d', RIGHT('0000' + CAST(@tfsid AS VARCHAR(10)), 5)), '%s', @dto)
        COMMIT;
    END; ELSE BEGIN
        SET @fmt = '[#%05d] Rolling back the transaction at %s...';
        RAISERROR(@fmt, 0, 0, @tfsid, @dto) WITH NOWAIT;
        IF @select_xact_msg = 1 SELECT REPLACE(REPLACE(@fmt COLLATE DATABASE_DEFAULT, '%05d', RIGHT('0000' + CAST(@tfsid AS VARCHAR(10)), 5)), '%s', @dto)
        ROLLBACK;
    END;
END TRY
BEGIN CATCH
    DECLARE @errline INT = ERROR_LINE(),
            @errmsg NVARCHAR(MAX) = ERROR_MESSAGE(),
            @errno INT = ERROR_NUMBER(),
            @errproc VARCHAR(MAX) = ERROR_PROCEDURE(),
            @errseverity INT = ERROR_SEVERITY(),
            @errstate INT = ERROR_STATE();

    RAISERROR('[#%05d] %s:%d %s (%d) (severity=%d state=%d)', 0, 0, @tfsid, @errproc, @errline, @errmsg, @errno, @errseverity, @errstate) WITH NOWAIT;

    RAISERROR('[#%05d] WARNING: %d transactions are being ROLLED BACK after an ERROR in the script!', 0, 0, @tfsid, @@TRANCOUNT) WITH NOWAIT;
    WHILE @@TRANCOUNT > 0 ROLLBACK;
END CATCH

IF @@TRANCOUNT > 0 BEGIN
    RAISERROR('[#%05d] WARNING: %d transactions are still OPEN after the script ended!', 0, 0, @tfsid, @@TRANCOUNT) WITH NOWAIT;
END;
