import json
import math


def main(base_directory, datasets):
    
    for ds in datasets:
        ds_directory = '{}/{}'.format(base_directory, ds['directory'])
        for net in ds['networks']:
            print(ds['name'], net)
            
            # GRAPH
            graph_filename = '{}/{}.graph'.format(ds_directory, net)
            json_filename = '{}/{}.graph.json'.format(ds_directory, net)
            text_filename = '{}/{}.graph.txt'.format(ds_directory, net)
            
            net_json = {}
            with open(graph_filename) as gf:
                for line in gf:
                    if line == '\n':
                        continue
                    else:
                        sl = line.split(' ')
                        if sl[0] == 'NODES':
                            net_json['n_nodes'] = int(sl[1])
                            net_json['nodes'] = []
                            
                            gf.readline()
                            node_ID = 0
                            for i in range(net_json['n_nodes']):
                                line = gf.readline()
                                sl = line.split(' ')
                                node = {
                                    'id': node_ID,
                                    'label': sl[0],
                                    'x': float(sl[1]),
                                    'y': float(sl[2])
                                }
                                net_json['nodes'].append(node)
                                node_ID = node_ID + 1
                            
                        elif sl[0] == 'EDGES':
                            net_json['n_edges'] = int(sl[1])
                            net_json['edges'] = []
                            
                            gf.readline()
                            edge_ID = 0
                            for i in range(net_json['n_edges']):
                                line = gf.readline()
                                sl = line.split(' ')
                                edge = {
                                    'id': edge_ID,
                                    'label': sl[0],
                                    'src': int(sl[1]),
                                    'dst': int(sl[2]),
                                    'weight': int(sl[3]),
                                    'bw': int(sl[4]),
                                    'delay': int(sl[5])
                                }
                                net_json['edges'].append(edge)
                                edge_ID = edge_ID + 1

            with open(json_filename, 'w') as jf:
                json.dump(net_json, jf, indent=2)
            
            with open(text_filename, 'w') as tf:
                tf.write('{} {}\n'.format(net_json['n_nodes'], net_json['n_edges']))
                for e in net_json['edges']:
                    tf.write('{} {}\n'.format(e['src'], e['dst']))

            # DEMANDS
            for demand in ds['demands']:
                matrix_json = {}
                
                demands_filename = '{}/{}{}.demands'.format(ds_directory, net, demand)
                json_filename = '{}/{}{}.demands.json'.format(ds_directory, net, demand)
                
                demands_json= {}
                with open(demands_filename) as df:
                    for line in df:
                        if line == '\n':
                            continue
                        else:
                            sl = line.split(' ')
                            if sl[0] == 'DEMANDS':
                                demands_json['n_demands'] = int(sl[1])
                                demands_json['demands_list'] = []
                                demands_json['demands_matrix'] = []
                                for i in range(net_json['n_nodes']):
                                    demands_json['demands_matrix'].append([0]*net_json['n_nodes'])
                                
                                df.readline()
                                demand_ID = 0
                                for i in range(demands_json['n_demands']):
                                    line = df.readline()
                                    sl = line.split(' ')
                                    
                                    src = int(sl[1])
                                    dst = int(sl[2])
                                    bw = int(sl[3])
#                                     bw = int(int(sl[3])*0.55)
                                    pktrate = int(math.ceil(bw*1000/(8*891)))  # avg 891-byte packets
                                    demand = {
                                        'id': demand_ID,
                                        'label': sl[0],
                                        'src': src,
                                        'dst': dst,
                                        'bw': bw,
                                        'pktrate': pktrate
                                    }
                                    demands_json['demands_matrix'][src][dst] = pktrate
                                    demands_json['demands_list'].append(demand)
                                    demand_ID = demand_ID + 1
                
                with open(json_filename, 'w') as jf:
                    json.dump(demands_json, jf, indent=2)

if __name__ == '__main__':

    # These datasets covers all topologies in TopologyZoo and RocketFuel
    datasets = [
        {"name": "TopologyZoo", "directory": "2016TopologyZooUCL_inverseCapacity", "demands": [".0000", ".0001", ".0002", ".0003", ".0004"], "networks": ["Aarnet", "Abilene", "Abvt", "Aconet", "Agis", "Ai3", "Airtel", "Amres", "Ans", "Arn", "Arnes", "Arpanet19706", "Arpanet19719", "Arpanet19723", "Arpanet19728", "Arpanet196912", "AsnetAm", "Atmnet", "AttMpls", "Azrena", "Bandcon", "Basnet", "Bbnplanet", "Bellcanada", "Bellsouth", "Belnet2003", "Belnet2004", "Belnet2005", "Belnet2006", "Belnet2007", "Belnet2008", "Belnet2009", "Belnet2010", "BeyondTheNetwork", "Bics", "Biznet", "Bren", "BsonetEurope", "BtAsiaPac", "BtEurope", "BtLatinAmerica", "BtNorthAmerica", "Canerie", "Carnet", "Cernet", "Cesnet1993", "Cesnet1997", "Cesnet1999", "Cesnet2001", "Cesnet200304", "Cesnet200511", "Cesnet200603", "Cesnet200706", "Cesnet201006", "Chinanet", "Claranet", "Cogentco", "Colt", "Columbus", "Compuserve", "CrlNetworkServices", "Cudi", "Cwix", "Cynet", "Darkstrand", "Dataxchange", "Deltacom", "DeutscheTelekom", "Dfn", "DialtelecomCz", "Digex", "Easynet", "Eenet", "EliBackbone", "Epoch", "Ernet", "Esnet", "Eunetworks", "Evolink", "Fatman", "Fccn", "Forthnet", "Funet", "Gambia", "Garr199901", "Garr199904", "Garr199905", "Garr200109", "Garr200112", "Garr200212", "Garr200404", "Garr200902", "Garr200908", "Garr200909", "Garr200912", "Garr201001", "Garr201003", "Garr201004", "Garr201005", "Garr201007", "Garr201008", "Garr201010", "Garr201012", "Garr201101", "Garr201102", "Garr201103", "Garr201104", "Garr201105", "Garr201107", "Garr201108", "Garr201109", "Garr201110", "Garr201111", "Garr201112", "Garr201201", "Gblnet", "Geant2001", "Geant2009", "Geant2010", "Geant2012", "Getnet", "Globalcenter", "Globenet", "Goodnet", "Grena", "Gridnet", "Grnet", "GtsCe", "GtsCzechRepublic", "GtsHungary", "GtsPoland", "GtsRomania", "GtsSlovakia", "Harnet", "Heanet", "HiberniaCanada", "HiberniaGlobal", "HiberniaIreland", "HiberniaNireland", "HiberniaUk", "HiberniaUs", "Highwinds", "HostwayInternational", "HurricaneElectric", "Ibm", "Iij", "Iinet", "Ilan", "Integra", "Intellifiber", "Internetmci", "Internode", "Interoute", "Intranetwork", "Ion", "IowaStatewideFiberMap", "Iris", "Istar", "Itnet", "Janetbackbone", "JanetExternal", "Janetlense", "Jgn2Plus", "Karen", "KentmanApr2007", "KentmanAug2005", "KentmanFeb2008", "KentmanJan2011", "KentmanJul2005", "Kreonet", "LambdaNet", "Latnet", "Layer42", "Litnet", "Marnet", "Marwan", "Missouri", "Mren", "Myren", "Napnet", "Navigata", "Netrail", "NetworkUsa", "Nextgen", "Niif", "Noel", "Nordu1989", "Nordu1997", "Nordu2005", "Nordu2010", "Nsfcnet", "Nsfnet", "Ntelos", "Ntt", "Oteglobe", "Oxford", "Pacificwave", "Packetexchange", "Padi", "Palmetto", "Peer1", "Pern", "PionierL1", "PionierL3", "Psinet", "Quest", "RedBestel", "Rediris", "Renam", "Renater1999", "Renater2001", "Renater2004", "Renater2006", "Renater2008", "Renater2010", "Restena", "Reuna", "Rhnet", "Rnp", "Roedunet", "RoedunetFibre", "Sago", "Sanet", "Sanren", "Savvis", "Shentel", "Sinet", "Singaren", "Spiralight", "Sprint", "Sunet", "Surfnet", "Switch", "SwitchL3", "Syringa", "TataNld", "Telcove", "Telecomserbia", "Tinet", "TLex", "Tw", "Twaren", "Ulaknet", "UniC", "Uninet", "Uninett2010", "Uninett2011", "Uran", "UsCarrier", "UsSignal", "Uunet", "Vinaren", "VisionNet", "VtlWavenet2008", "VtlWavenet2011", "WideJpn", "Xeex", "Xspedius", "York", "Zamren"]},
        {"name": "DEFO", "directory": "2015DEFO", "demands": [""], "networks": ["rf1221_real_hard", "rf1239_real_hard", "rf1755_real_hard", "rf3257_real_hard", "rf3967_real_hard", "rf6461_real_hard", "synth50_opt_hard", "synth100_opt_hard", "synth200_unary_hard"]}
    ]

    main('./Repetita/data/', datasets)