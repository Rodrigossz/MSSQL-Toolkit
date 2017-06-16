--drop trigger CategoriaArquivo_TG01
--drop trigger Extensao_TG01

use PsafeDb
go
select * from CategoriaArquivo
select * from Extensao order by 1
--delete EspacoPc
delete Extensao where id > 6
dbcc checkident ('Extensao','reseed',6)


--Excluidos
insert extensao select '*.8BF',6
insert extensao select '*.APP',6
insert extensao select '*.BAC',6
insert extensao select '*.BPL',6
insert extensao select '*.Bundle',6
insert extensao select '*.Class',6
insert extensao select '*.COFF',6
insert extensao select '*.com',6
insert extensao select '*.DCU',6
insert extensao select '*.dll',6
insert extensao select '*.DOL',6
insert extensao select '*.EAR',6
insert extensao select '*.ELF',6
insert extensao select '*.exe',6
insert extensao select '*.ilk',6
insert extensao select '*.JAR',6
insert extensao select '*.NLM',6
insert extensao select '*.O',6
insert extensao select '*.ocx',6
insert extensao select '*.pdb',6
insert extensao select '*.s1es',6
insert extensao select '*.sys',6
insert extensao select '*.TLB',6
insert extensao select '*.VAP',6
insert extensao select '*.VBX',6
insert extensao select '*.WAR',6
insert extensao select '*.XBE',6
insert extensao select '*.XCOFF',6
insert extensao select '*.XEX',6
insert extensao select '*.XPI',6


--Video
insert extensao select '*.3GP',4
insert extensao select '*.AAF',4
insert extensao select '*.ASF',4
insert extensao select '*.AVCHD',4
insert extensao select '*.AVI',4
insert extensao select '*.CAM',4
insert extensao select '*.DAT',4
insert extensao select '*.DSH',4
insert extensao select '*.FCP',4
insert extensao select '*.FLA',4
insert extensao select '*.FLR',4
insert extensao select '*.FLV',4
insert extensao select '*.IMOVIEPROJ',4
insert extensao select '*.m1v',4
insert extensao select '*.M2TS',4
insert extensao select '*.m2v',4
insert extensao select '*.m4a',4
insert extensao select '*.m4p',4
insert extensao select '*.M4V',4
insert extensao select '*.mkv',4
insert extensao select '*.MNG',4
insert extensao select '*.mov',4
insert extensao select '*.mp4',4
insert extensao select '*.mpe',4
insert extensao select '*.mpeg',4
insert extensao select '*.mpeg-1',4
insert extensao select '*.mpeg-2',4
insert extensao select '*.mpeg-4',4
insert extensao select '*.mpg',4
insert extensao select '*.MSWMM',4
insert extensao select '*.MXF',4
insert extensao select '*.NSV',4
insert extensao select '*.Ogg',4
insert extensao select '*.PPJ',4
insert extensao select '*.RM',4
insert extensao select '*.ROQ',4
insert extensao select '*.SMI',4
insert extensao select '*.SOL',4
insert extensao select '*.SUF',4
insert extensao select '*.SVI',4
insert extensao select '*.SWF',4
insert extensao select '*.veg',4
insert extensao select '*.veg-bak',4
insert extensao select '*.WMV',4
insert extensao select '*.WRAP',4
		
		
--Musica
insert extensao select '*.2sf',2
insert extensao select '*.aac',2
insert extensao select '*.AIFF',2
insert extensao select '*.ALS',2
insert extensao select '*.AMR',2
insert extensao select '*.APE',2
--insert extensao select '*.ASF',2  VIDEO
insert extensao select '*.ASX',2
insert extensao select '*.AU',2
insert extensao select '*.AUP',2
insert extensao select '*.BAND',2
insert extensao select '*.CDDA',2
insert extensao select '*.CEL',2
insert extensao select '*.CPR',2
insert extensao select '*.CUST',2
insert extensao select '*.CWP',2
insert extensao select '*.DRM',2
insert extensao select '*.dsf',2
insert extensao select '*.DWD',2
insert extensao select '*.FLAC',2
insert extensao select '*.gsf',2
insert extensao select '*.GSM',2
insert extensao select '*.GYM',2
insert extensao select '*.IFF-16SV',2
insert extensao select '*.IFF-8SVX',2
insert extensao select '*.IT',2
insert extensao select '*.JAM',2
insert extensao select '*.LA',2
insert extensao select '*.LY',2
insert extensao select '*.M3U',2
--insert extensao select '*.M4A',2 VIDEO
insert extensao select '*.MID',2
insert extensao select '*.MMR',2
--insert extensao select '*.MNG',2 VIDEO
insert extensao select '*.MOD',2
insert extensao select '*.MP1',2
insert extensao select '*.MP2',2
insert extensao select '*.MP3',2
insert extensao select '*.MPC',2
insert extensao select '*.MSCZ',2
insert extensao select '*.MT2',2
insert extensao select '*.MUS',2
insert extensao select '*.MusicXML',2
insert extensao select '*.niff',2
insert extensao select '*.NPR',2
insert extensao select '*.NSF',2
insert extensao select '*.OMF',2
insert extensao select '*.OptimFROG',2
insert extensao select '*.OTS',2
insert extensao select '*.PAC',2
insert extensao select '*.PLS',2
insert extensao select '*.PSF',2
insert extensao select '*.psf2',2
insert extensao select '*.psflib',2
insert extensao select '*.PTB',2
insert extensao select '*.qsf',2
insert extensao select '*.ra',2
insert extensao select '*.RAM',2
--insert extensao select '*.RAW',2 foto
insert extensao select '*.RKA',2
--insert extensao select '*.rm',2 VIDEO
insert extensao select '*.RMJ',2
insert extensao select '*.S3M',2
insert extensao select '*.SES',2
insert extensao select '*.SHN',2
insert extensao select '*.SIB',2
insert extensao select '*.SMP',2
insert extensao select '*.SND',2
insert extensao select '*.SNG',2
insert extensao select '*.SPC',2
insert extensao select '*.Speex',2
insert extensao select '*.ssf',2
insert extensao select '*.STF',2
insert extensao select '*.SWA',2
insert extensao select '*.SYN',2
insert extensao select '*.TTA',2
insert extensao select '*.TXM',2
insert extensao select '*.usf',2
insert extensao select '*.VGM',2
insert extensao select '*.VOC',2
insert extensao select '*.VOX',2
insert extensao select '*.VQF',2
insert extensao select '*.WAV',2
insert extensao select '*.WMA',2
insert extensao select '*.WV',2
insert extensao select '*.XM',2
insert extensao select '*.XSPF',2
insert extensao select '*.YM',2
insert extensao select '*.ZPL',2
		
		
--Fotos
insert extensao select '*.ART',3
insert extensao select '*.ASE',3
insert extensao select '*.BLP',3
insert extensao select '*.BMP',3
insert extensao select '*.bw',3
insert extensao select '*.ccitt',3
insert extensao select '*.CIT',3
insert extensao select '*.cmyk',3
insert extensao select '*.CPT',3
insert extensao select '*.CUT',3
insert extensao select '*.DDS',3
insert extensao select '*.DIB',3
insert extensao select '*.DjVu',3
insert extensao select '*.EGT',3
insert extensao select '*.Exif',3
insert extensao select '*.GIF',3
insert extensao select '*.GPL',3
insert extensao select '*.ibm',3
insert extensao select '*.icb',3
insert extensao select '*.ICNS',3
insert extensao select '*.ICO',3
insert extensao select '*.iff',3
insert extensao select '*.ilbm',3
insert extensao select '*.int',3
insert extensao select '*.jfif',3
insert extensao select '*.JNG',3
insert extensao select '*.JP2',3
insert extensao select '*.jpeg',3
insert extensao select '*.jpg',3
insert extensao select '*.JPS',3
insert extensao select '*.LBM',3
insert extensao select '*.lzw',3
insert extensao select '*.MAX',3
insert extensao select '*.MIFF',3
--insert extensao select '*.MNG',3 duplicado video
insert extensao select '*.MSP',3
insert extensao select '*.NITF',3
insert extensao select '*.ota',3
insert extensao select '*.PBM',3
insert extensao select '*.PC1',3
insert extensao select '*.PC2',3
insert extensao select '*.PC3',3
insert extensao select '*.PCF',3
insert extensao select '*.pct',3
insert extensao select '*.PCX',3
insert extensao select '*.pdd',3
insert extensao select '*.PDN',3
insert extensao select '*.PGM',3
insert extensao select '*.PI1',3
insert extensao select '*.PI2',3
insert extensao select '*.PI3',3
insert extensao select '*.pict',3
insert extensao select '*.pix',3
insert extensao select '*.PNG',3
insert extensao select '*.PNM',3
insert extensao select '*.PNS',3
insert extensao select '*.PPM',3
insert extensao select '*.PSB',3
insert extensao select '*.psd',3
insert extensao select '*.PSP',3
insert extensao select '*.PX',3
insert extensao select '*.PXR',3
insert extensao select '*.QFX',3
insert extensao select '*.RAW',3
insert extensao select '*.rgb',3
insert extensao select '*.RLE',3
insert extensao select '*.SCT',3
insert extensao select '*.sgi',3
insert extensao select '*.targa',3
insert extensao select '*.tga',3
insert extensao select '*.tif',3
insert extensao select '*.tiff',3
insert extensao select '*.vda',3
insert extensao select '*.vst',3
insert extensao select '*.XBM',3
insert extensao select '*.XCF',3
insert extensao select '*.XPM',3
insert extensao select '*.ycbcr',3

--Docs

insert extensao select '*.123',1
insert extensao select '*.3DM',1
insert extensao select '*.3DMF',1
insert extensao select '*.3dmlw',1
insert extensao select '*.3DS',1
insert extensao select '*.3DV',1
insert extensao select '*.3dxml',1
insert extensao select '*.ABW',1
insert extensao select '*.AC',1
insert extensao select '*.ACL',1
insert extensao select '*.ACP',1
insert extensao select '*.AFP',1
insert extensao select '*.AI',1
insert extensao select '*.AMF',1
insert extensao select '*.ANS',1
insert extensao select '*.AOI',1
insert extensao select '*.AR',1
--insert extensao select '*.ART',1 duplicado video
insert extensao select '*.ASC',1
insert extensao select '*.ASM',1
insert extensao select '*.AWG',1
insert extensao select '*.AWS',1
insert extensao select '*.AWW',1
insert extensao select '*.B3D',1
insert extensao select '*.bib',1
insert extensao select '*.BIM',1
insert extensao select '*.BIN',1
insert extensao select '*.BLEND',1
insert extensao select '*.BLOCK',1
insert extensao select '*.BRD',1
insert extensao select '*.BSDL',1
insert extensao select '*.C4D',1
insert extensao select '*.CAD',1
insert extensao select '*.Cal3D',1
insert extensao select '*.CATDrawing',1
insert extensao select '*.CATPart',1
insert extensao select '*.CATProcess',1
insert extensao select '*.CATProduct',1
insert extensao select '*.CCC',1
insert extensao select '*.CCM',1
insert extensao select '*.CCP4',1
insert extensao select '*.CCS',1
insert extensao select '*.CDL',1
insert extensao select '*.CDR',1
insert extensao select '*.CELL',1
insert extensao select '*.CFL',1
insert extensao select '*.CGM',1
insert extensao select '*.CGR',1
insert extensao select '*.CLF',1
insert extensao select '*.CMX',1
insert extensao select '*.CO',1
insert extensao select '*.COB',1
insert extensao select '*.CORE3D',1
insert extensao select '*.CPF',1
insert extensao select '*.CSS',1
insert extensao select '*.CSV',1
insert extensao select '*.CTM',1
insert extensao select '*.CWK',1
insert extensao select '*.DAE',1
insert extensao select '*.db',1
insert extensao select '*.DEF',1
insert extensao select '*.DFF',1
insert extensao select '*.DFT',1
insert extensao select '*.DGK',1
insert extensao select '*.DGN',1
insert extensao select '*.dif',1
insert extensao select '*.DMT',1
insert extensao select '*.DOC',1
insert extensao select '*.DOCX',1
insert extensao select '*.DOT',1
insert extensao select '*.DOTX',1
insert extensao select '*.DPM',1
insert extensao select '*.DRW',1
insert extensao select '*.DSPF',1
insert extensao select '*.DTP',1
insert extensao select '*.DTS',1
insert extensao select '*.DVI',1
insert extensao select '*.DWB',1
insert extensao select '*.DWF',1
insert extensao select '*.DWG',1
insert extensao select '*.DXF',1
insert extensao select '*.E2D',1
insert extensao select '*.EDIF',1
insert extensao select '*.EGG',1
--insert extensao select '*.EGT',1 duplicado
insert extensao select '*.EMB',1
insert extensao select '*.EMF',1
insert extensao select '*.enl',1
insert extensao select '*.EPS',1
insert extensao select '*.ESW',1
insert extensao select '*.EXCELLON',1
insert extensao select '*.FACT',1
insert extensao select '*.FBX',1
insert extensao select '*.FDX',1
insert extensao select '*.FM',1
insert extensao select '*.FMZ',1
insert extensao select '*.FSDB',1
insert extensao select '*.FTM',1
insert extensao select '*.FTX',1
insert extensao select '*.GDSII',1
insert extensao select '*.GERBER',1
insert extensao select '*.GLM',1
insert extensao select '*.gnumeric',1
insert extensao select '*.GRB',1
insert extensao select '*.GTC',1
insert extensao select '*.HEX',1
insert extensao select '*.HTML',1
insert extensao select '*.HWP',1
insert extensao select '*.HWPML',1
insert extensao select '*.IAM',1
insert extensao select '*.ICD',1
insert extensao select '*.IDW',1
insert extensao select '*.IFC',1
insert extensao select '*.IGES',1
insert extensao select '*.INDD',1
insert extensao select '*.INFO',1
insert extensao select '*.IPN',1
insert extensao select '*.IPT',1
insert extensao select '*.KEY',1
insert extensao select '*.KEYNOTE',1
insert extensao select '*.LEF',1
insert extensao select '*.LIB',1
insert extensao select '*.LWO',1
insert extensao select '*.LWP',1
insert extensao select '*.LWS',1
insert extensao select '*.LXO',1
insert extensao select '*.MA',1
--insert extensao select '*.MAX',1 duplicado
insert extensao select '*.MB',1
insert extensao select '*.MCD',1
insert extensao select '*.MCF',1
insert extensao select '*.MCW',1
insert extensao select '*.MD2',1
insert extensao select '*.MD3',1
insert extensao select '*.MDX',1
insert extensao select '*.MESH',1
insert extensao select '*.MM3D',1
insert extensao select '*.MPP',1
insert extensao select '*.MRC',1
insert extensao select '*.MS10',1
insert extensao select '*.NB',1
insert extensao select '*.NBP',1
insert extensao select '*.NIF',1
insert extensao select '*.numbers',1
insert extensao select '*.OASIS',1
insert extensao select '*.OBJ',1
insert extensao select '*.ODG',1
insert extensao select '*.ODM',1
insert extensao select '*.ODP',1
insert extensao select '*.ODS',1
insert extensao select '*.ODT',1
insert extensao select '*.OFF',1
insert extensao select '*.OpenAccess',1
insert extensao select '*.OTP',1
--insert extensao select '*.OTS',1 duplicado
insert extensao select '*.OTT',1
insert extensao select '*.PAGES',1
insert extensao select '*.PAP',1
insert extensao select '*.PAR',1
insert extensao select '*.PCL',1
insert extensao select '*.PDAX',1
insert extensao select '*.PDF',1
insert extensao select '*.PLD',1
insert extensao select '*.PLN',1
insert extensao select '*.PMD',1
insert extensao select '*.POT',1
insert extensao select '*.POV',1
insert extensao select '*.PPP',1
insert extensao select '*.PPS',1
insert extensao select '*.PPT',1
insert extensao select '*.PPTX',1
insert extensao select '*.PRC',1
insert extensao select '*.PRT',1
insert extensao select '*.PRZ',1
insert extensao select '*.PSM',1
insert extensao select '*.PSMODEL',1
insert extensao select '*.PUB',1
insert extensao select '*.PWI',1
insert extensao select '*.PYT',1
insert extensao select '*.QPW',1
insert extensao select '*.QUOX',1
insert extensao select '*.RFA',1
insert extensao select '*.ris',1
insert extensao select '*.RLF',1
insert extensao select '*.RPT',1
insert extensao select '*.RTF',1
insert extensao select '*.RVT',1
insert extensao select '*.RWX',1
insert extensao select '*.SDC',1
insert extensao select '*.SDD',1
insert extensao select '*.SDF',1
insert extensao select '*.SDW',1
insert extensao select '*.SHF',1
insert extensao select '*.SHOW',1
insert extensao select '*.SHW',1
insert extensao select '*.SIA',1
--insert extensao select '*.SIB',1 duplicado
insert extensao select '*.SKP',1
insert extensao select '*.SLDASM',1
insert extensao select '*.SLDDRW',1
insert extensao select '*.SLDPRT',1
insert extensao select '*.SLK',1
insert extensao select '*.SLP',1
insert extensao select '*.SMD',1
insert extensao select '*.SNP',1
insert extensao select '*.SPEF',1
insert extensao select '*.SPI',1
insert extensao select '*.SREC',1
insert extensao select '*.SSPSS',1
insert extensao select '*.STC',1
insert extensao select '*.STEP',1
insert extensao select '*.STI',1
insert extensao select '*.STL',1
insert extensao select '*.STW',1
insert extensao select '*.SV',1
insert extensao select '*.SVG',1
insert extensao select '*.SXC',1
insert extensao select '*.SXD',1
insert extensao select '*.SXI',1
insert extensao select '*.SXW',1
insert extensao select '*.TAB',1
insert extensao select '*.TCT',1
insert extensao select '*.TCW',1
insert extensao select '*.TEX',1
insert extensao select '*.TPL',1
insert extensao select '*.Troff',1
insert extensao select '*.TSV',1
insert extensao select '*.TXT',1
insert extensao select '*.U3D',1
insert extensao select '*.UNV',1
insert extensao select '*.UOF',1
insert extensao select '*.UOML',1
insert extensao select '*.UPF',1
insert extensao select '*.V',1
insert extensao select '*.V2D',1
insert extensao select '*.VC',1
insert extensao select '*.VC6',1
insert extensao select '*.VCD',1
insert extensao select '*.VHD',1
insert extensao select '*.VHDL',1
insert extensao select '*.VLM',1
insert extensao select '*.VRML',1
insert extensao select '*.VS',1
insert extensao select '*.VUE',1
insert extensao select '*.WATCH',1
insert extensao select '*.WINGS',1
insert extensao select '*.WK1',1
insert extensao select '*.WK3',1
insert extensao select '*.WK4',1
insert extensao select '*.WKS',1
insert extensao select '*.WMF',1
insert extensao select '*.WPD',1
insert extensao select '*.WPS',1
insert extensao select '*.WPT',1
insert extensao select '*.WQ1',1
insert extensao select '*.WRD',1
insert extensao select '*.WRF',1
insert extensao select '*.WRI',1
insert extensao select '*.WRL',1
insert extensao select '*.X',1
insert extensao select '*.X3D',1
insert extensao select '*.XAR',1
insert extensao select '*.XE',1
insert extensao select '*.XHT',1
insert extensao select '*.XHTML',1
insert extensao select '*.XLK',1
insert extensao select '*.XLR',1
insert extensao select '*.XLS',1
insert extensao select '*.XLSB',1
insert extensao select '*.XLSM',1
insert extensao select '*.XLSX',1
insert extensao select '*.XLT',1
insert extensao select '*.XLTM',1
insert extensao select '*.XLW',1
insert extensao select '*.XML',1
insert extensao select '*.XPS',1
insert extensao select '*.XSL',1
insert extensao select '*.XSL-FO',1
insert extensao select '*.XSLT',1
insert extensao select '*.Z3D',1


--select * from Extensao order by 1

select COUNT(*) from Extensao
go

create PROC [dbo].[pr_Extensao_sel_categoriaArquivoId]	@categoriaArquivoId tinyintWITH EXECUTE AS OWNERASSET NOCOUNT ONSELECT * FROM Extensao (nolock) WHERE categoriaArquivoId = @categoriaArquivoIdSET NOCOUNT OFF--go--USE [PsafeDb]
--GO

--alter trigger [dbo].[CategoriaArquivo_TG01] on [dbo].[CategoriaArquivo]
--for update
--as
--begin
--update MudancaCategoriasExtensoes set dataHora = GETDATE()
--if @@ROWCOUNT = 0
--insert MudancaCategoriasExtensoes select GETDATE()
--end
--go
--ALTER trigger [dbo].[Extensao_TG01] on [dbo].[Extensao]
--for update
--as
--begin
--update MudancaCategoriasExtensoes set dataHora = GETDATE()
--if @@ROWCOUNT = 0
--insert MudancaCategoriasExtensoes select GETDATE()
--end
--GO


--/**************************/

--create trigger [dbo].[CategoriaArquivo_TG02] on [dbo].[CategoriaArquivo]
--for insert,update,delete
--as
--begin
--update MudancaCategoriasExtensoes set dataHora = GETDATE()
--if @@ROWCOUNT = 0
--insert MudancaCategoriasExtensoes select GETDATE()
--end
--go


--create trigger [dbo].[Extensao_TG02] on [dbo].[Extensao]
--for insert,update,delete
--as
--begin
--update MudancaCategoriasExtensoes set dataHora = GETDATE()
--if @@ROWCOUNT = 0
--insert MudancaCategoriasExtensoes select GETDATE()
--end

--GO
