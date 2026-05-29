# pip install pypdf

import os
from pypdf import PdfReader, PdfWriter

def split_all_pdfs_in_dir():
    # 1. 获取当前运行目录
    current_dir = os.getcwd()
    
    # 2. 列出当前目录下所有的文件，并过滤出 .pdf 文件
    all_files = os.listdir(current_dir)
    pdf_files = [f for f in all_files if f.lower().endswith('.pdf')]
    
    if not pdf_files:
        print("当前目录下未找到任何 PDF 文件。")
        return

    print(f"找到 {len(pdf_files)} 个 PDF 文件，准备开始处理...\n")

    # 3. 遍历每个 PDF 文件进行处理
    for pdf_file in pdf_files:
        # 获取文件名（不含扩展名），用作新文件夹的名字
        file_name_without_ext = os.path.splitext(pdf_file)[0]
        
        # 创建专属目标文件夹路径
        target_dir = os.path.join(current_dir, file_name_without_ext)
        
        # 如果文件夹不存在则创建
        if not os.path.exists(target_dir):
            os.makedirs(target_dir)
            print(f"已创建专属文件夹: {file_name_without_ext}/")
        
        try:
            # 读取当前 PDF 文件
            pdf_path = os.path.join(current_dir, pdf_file)
            reader = PdfReader(pdf_path)
            total_pages = len(reader.pages)
            
            print(f"正在拆分 [{pdf_file}] (共 {total_pages} 页):")
            
            # 4. 循环将每一页保存到该专属文件夹中
            for index, page in enumerate(reader.pages):
                writer = PdfWriter()
                writer.add_page(page)
                
                # 构造单页 PDF 的文件名，例如: "report_page_01.pdf"
                # {:02d} 可以让个位数自动补零（01, 02），方便文件在文件夹里按顺序排列
                output_filename = f"{file_name_without_ext}_page_{index + 1:02d}.pdf"
                output_path = os.path.join(target_dir, output_filename)
                
                with open(output_path, "wb") as out_file:
                    writer.write(out_file)
            
            print(f"完成！[{pdf_file}] 的所有页面已成功移入文件夹。\n")
            
        except Exception as e:
            print(f"处理文件 {pdf_file} 时发生错误: {e}\n")

if __name__ == "__main__":
    split_all_pdfs_in_dir()
