#This code imports csv files that contain each mapped boulder's distance down
#an LDA and writes a new csv with the number of boulders in each of 100 bins.
#This code must be in the same folder as the csv files it is reading.
#
import os
def find_column(line, column_names):
    '''
    (str, str) -> str or None
    Input the text in one line of a csv and the name of the desired column
    to read. Returns the column number if the column name is found, None
    otherwise.
    '''
    word_list = line.strip(' \ufeff \n').split(',')
    word_num = 0
    while word_num < len(word_list):
        if word_list[word_num] in column_names:
            return word_num
        word_num += 1
    return None

def csv_to_list(filename, column_names):
    '''
    (str, list) -> list
    Input the name of the csv file to be read and a list of variations of a
    column name (this was required because the normalized distance was written
    as both 'xnorm' and 'normx' in the csv files). All column names refer to 
    name variations of one variable only. This code with not make lists for
    multiple variable at once.
    Returns list of values in the desired column of the csv file.
    '''
    with open(filename) as infile:
        field_list = []
        line_num = 0
        for line in infile:
            if line_num == 0:
                column = find_column(line, column_names)
            else:
                field_list += [float(line.split(',')[column])]
            line_num += 1
    return field_list
                        
def calculate_density_bins(new_filename, field_list):
    '''
    (str, list) -> None
    Input name of new csv file being written and list of values that are being
    binned. This function will create 100 bins in a new csv file within the
    local folder. Column 1 is the bin number, and column 2 is the number of
    values in that bin.
    Returns None.
    '''
    with open(new_filename, 'w') as outfile:
        outfile.write('bin' + ',' + 'boulder_density' + '\n')
        for i in range(1, 101):
            bin_upper_bound = i/100
            bin_lower_bound = (i-1)/100
            bin_total = 0
            for value in field_list:
                if bin_lower_bound <= value < bin_upper_bound:
                    bin_total += 1
            outfile.write(str(int(bin_upper_bound * 100)))
            outfile.write(',')
            outfile.write(str(bin_total))
            outfile.write('\n')
def main():
    '''
    () -> None
    Retrieves the names of all files in the folder and creates a list of names
    that include the word 'site'. Runs the csv_to_list and calculate_density_bins
    function for this list of files names. Outgoing file names are simply the
    incoming file name with _bins appended to it.
    '''
    name_list = os.listdir()
    infilename_list = []
    for name in name_list:
        if 'site' in name.split('.')[0]:
            infilename_list += [name]
    infile_outfile = {}
    for infilename in infilename_list:
        infile_outfile[infilename] = infilename.split('.')[0] + '_bins' + '.csv'
    print(infile_outfile)
    for infile in infile_outfile:
        field_list = csv_to_list(infile, ['xnorm', 'normx'])
        calculate_density_bins(infile_outfile[infile], field_list)
        print('done')

def single_file(infilename):
    '''
    (str) -> None
    Input name of file to read and bin.
    '''
    field_list = csv_to_list(infilename, ['xnorm', 'normx'])
    new_filename = infilename.split('.')[0] + '_bins' + '.csv'
    calculate_density_bins(new_filename, field_list)

    
        
